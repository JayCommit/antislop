# Before and after

The examples use Python for readability. Apply the judgment in the host project's language and conventions; do not introduce these structures merely to match the examples.

## A fixed export does not need a format framework

Requirement: export rows to CSV text. There are no other formats or consumers of a format selector.

Before:

```python
import csv
import io

class CsvExporter:
    def export(self, rows):
        output = io.StringIO(newline="")
        csv.writer(output).writerows(rows)
        return output.getvalue()

class ExporterFactory:
    def create(self, format_name):
        if format_name == "csv":
            return CsvExporter()
        raise ValueError(f"Unsupported format: {format_name}")

def export_report(rows):
    return ExporterFactory().create("csv").export(rows)
```

After:

```python
import csv
import io

def export_report(rows):
    output = io.StringIO(newline="")
    csv.writer(output).writerows(rows)
    return output.getvalue()
```

The ordinary path is visible in one place and CSV escaping stays intact. Joining fields with commas would be shorter but would break quoted fields and embedded newlines. Verify those cases and empty input. Keep format selection if current callers actually select formats; preserve any public factory API unless changing it is in scope.

## Similar loops can represent different policies

Requirement: show active users and paid invoices. These filters belong to separate features and evolve independently.

Before:

```python
def select_records(records, kind):
    field = "active" if kind == "user" else "paid"
    return [record for record in records if record[field]]

active_users = select_records(users, "user")
paid_invoices = select_records(invoices, "invoice")
```

After:

```python
active_users = [user for user in users if user["active"]]
paid_invoices = [invoice for invoice in invoices if invoice["paid"]]
```

The shared helper connects unrelated domain concepts and treats unknown kinds as invoices. Keeping each policy local makes a later invoice rule independent of user activation. If filtering grows into a named domain rule, extract that rule near its feature. A general filtering facility may still be appropriate if the project already has one that fits.

## Comments should preserve knowledge

Before:

```python
# Loop through all items and add the amounts.
total = sum(item.amount for item in items)
```

After:

```python
total = sum(item.amount for item in items)
```

Keep comments that explain a constraint a maintainer cannot infer:

```python
# The supplier signs the original bytes; parsing and re-encoding invalidates it.
verify_signature(raw_body, signature)
```

Deleting every comment would remove useful operational knowledge.

## A one-caller boundary can still be valuable

Requirement: a checkout operation charges through an external payment provider. The project already uses this adapter, and callers rely on its domain error.

```python
class Payments:
    def __init__(self, client):
        self.client = client

    def charge(self, amount, idempotency_key):
        try:
            return self.client.charge(
                amount=amount,
                idempotency_key=idempotency_key,
            )
        except ProviderDeclined as error:
            raise PaymentDeclined() from error
```

Retain this boundary even with one caller: it translates a provider failure and centralizes the provider contract. Keep the idempotency key and let unexpected errors propagate according to the existing contract. Moving provider calls and error translation into checkout merely to remove a class would spread dependency details into business behavior. No rewrite is needed without a demonstrated cost.

## A helper can name policy without generalizing it

```python
def can_cancel(order):
    return order.status in {"pending", "confirmed"} and not order.dispatched
```

Keep this when cancellation eligibility is a domain concept callers need to understand. Replacing it with a configurable `RuleEngine` needs evidence of current requirements. Inlining it everywhere would make a shared policy easier to change inconsistently. One caller alone does not decide the right shape.
