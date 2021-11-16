# Error reproduction for Google Cloud Run + Cloud SQL

To reproduce:

1. Update the variables in the Makefile.
2. Run `make deploy`
3. Once deployed, navigate to `https://{HOST}/`. The first time it connects to the database and returns a result, but second time it hangs.
