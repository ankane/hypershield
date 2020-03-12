# Specify which environments to use Hypershield
Hypershield.enabled = !Rails.env.development? && !Rails.env.test?

# Specify the schema to use and columns to show and hide
Hypershield.schemas = {
  hypershield: {
    # columns to hide
    # matches table.column
    hide: ["encrypted", "password", "token", "secret"],
    # overrides hide
    # matches table.column
    show: []
  }
}

# Log SQL statements
Hypershield.log_sql = false
