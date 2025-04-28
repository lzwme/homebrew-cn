class Driftwood < Formula
  desc "Private key usage verification"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritydriftwoodarchiverefstagsv1.0.1.tar.gz"
  sha256 "655e7f5841a97820adf11b608b41f88cc93953c8c5e1d497bdbd86e5662b2621"
  license "Apache-2.0"
  head "https:github.comtrufflesecuritydriftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "248ffb3e4e1f77251d56f7a9c0a0ed6be2b90c4d31e151ad0ea96a1914f47403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05adc63ca02329151e5f5b07639f7dec8de81608b3806ee9dbe3319798bfda5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bedf93a308a393359152d89abfd3a7abe810ad639e70f76291997b846e85dd24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bedf93a308a393359152d89abfd3a7abe810ad639e70f76291997b846e85dd24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bedf93a308a393359152d89abfd3a7abe810ad639e70f76291997b846e85dd24"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcec67bfc00bb285a5311fbd2e3cf079d98c6a5509ec5c5b847237652beac0ae"
    sha256 cellar: :any_skip_relocation, ventura:        "45bd8ae86b45b33f711d1408048742ba539a0e5246b1328b6bcc1797f81b2413"
    sha256 cellar: :any_skip_relocation, monterey:       "45bd8ae86b45b33f711d1408048742ba539a0e5246b1328b6bcc1797f81b2413"
    sha256 cellar: :any_skip_relocation, big_sur:        "45bd8ae86b45b33f711d1408048742ba539a0e5246b1328b6bcc1797f81b2413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f23e0f3345fb5ee170a3572e9c02243b531c471ff5691ca9e6121454f93594b2"
  end

  deprecate! date: "2025-04-27", because: :repo_archived, replacement_formula: "trufflehog"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # fake self-signed cert
    (testpath"fake.pem").write <<~EOS
      -----BEGIN CERTIFICATE-----
      MIID8zCCAtugAwIBAgIUEA5o49g6pqyhfG0NwT8lggIJGt0wDQYJKoZIhvcNAQEL
      BQAwgYgxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJOWTERMA8GA1UEBwwITmV3IFlv
      cmsxETAPBgNVBAoMCEhvbWVicmV3MRYwFAYDVQQLDA1ob21lYnJldy1jb3JlMREw
      DwYDVQQDDAhicmV3dGVzdDEbMBkGCSqGSIb3DQEJARYMdGVzdEBicmV3LnNoMB4X
      DTIzMDcwMzIyMTk1N1oXDTMzMDYzMDIyMTk1N1owgYgxCzAJBgNVBAYTAlVTMQsw
      CQYDVQQIDAJOWTERMA8GA1UEBwwITmV3IFlvcmsxETAPBgNVBAoMCEhvbWVicmV3
      MRYwFAYDVQQLDA1ob21lYnJldy1jb3JlMREwDwYDVQQDDAhicmV3dGVzdDEbMBkG
      CSqGSIb3DQEJARYMdGVzdEBicmV3LnNoMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
      MIIBCgKCAQEAtzNxXwjc+X3gmLqwR85M5m1JXYT4KNv8lSRM81Mp1T4xgLCXRAzH
      edzmcUveau1nPxQdvJpwz1XY9cnBze77xnew8kcfakKqrqPHFrn87NHm9kUIIc
      OK7YRCCwrBCZh0DKqZ8eCymWe85Ezl98AuhE+lKxjg+GdmAB6CMWNIm6+zW+ur
      FEpmzcxPzX0mreeoXLbkg1Hvvw84GuuG2QEKXbUX5be+xMhpGm0NYINUBcjvUWa3
      8+1pLJzx346MKQIIdQVdKkBU85kW2huNjrgT9RSpWoLsKBH8d0S5lInCdFcGpiOF
      s3D2gAJdhh6pVq2F75KooTiW7A4sGDMGUwIDAQABo1MwUTAdBgNVHQ4EFgQUfVU0
      LlOMixqYSC+9jtrKcKGuFQwHwYDVR0jBBgwFoAUfVU0LlOMixqYSC+9jtrKcKG
      uFQwDwYDVR0TAQHBAUwAwEBzANBgkqhkiG9w0BAQsFAAOCAQEAEiDn0ikzXX26
      NT85Zxv47+tMaDtOcZl9VgtYUSHl8Aj6ihLZzJXZdHYZis8Izmfmtv7qiQ+fBV
      Y2RwRMPycm6jMdrfZey1cgRdRtp5yPtLdEndixbQ9uAAXRSCW4D628QpTKK8D0O
      cw5BOZ2Vg5ckAjtsFxvzBr1wobOPXTa9FAKPUJaWiD3z4z4Jd2YdY6CGiPIQpaIF
      VWqWT1a4Nq7cNabnshtjNwU09Fo1B6Mf12u5QjsWF3AdJlVF54DJEB4uNVWaQEW
      qHrD+Any5JCDu1qnVepBEoH1EosIXWa6s1UHCB61i3lbZW54Xhj1KVfLsVg4wfmJ
      3zxOo0lNLQ==
      -----END CERTIFICATE-----
    EOS

    output = shell_output("#{bin}driftwood #{testpath}fake.pem 2>&1", 1)
    assert_match "Error computing public key: unsupported key type \\\"CERTIFICATE\\\"", output

    assert_match version.to_s, shell_output("#{bin}driftwood --version")
  end
end