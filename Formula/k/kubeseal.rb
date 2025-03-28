class Kubeseal < Formula
  desc "Kubernetes controller and tool for one-way encrypted Secrets"
  homepage "https:github.combitnami-labssealed-secrets"
  url "https:github.combitnami-labssealed-secrets.git",
      tag:      "v0.29.0",
      revision: "0d9cfaf99f23a344df8be86cf62d4aaad0d81be8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b58bb79b672df2daddcabfc8ef2af45ef9a215e9b58bc45e31ba2e8a81344d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dcf342a052a073cc0be51f67ff9881a94887648df08afed02b02821d25c5796"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fa498ed0743946732c9d05e8a1ef9d1582f33c2bd64991357acf7bf0b05637b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5f78e950774f72d8c03e420358088ea1a1cbd0065d568724d13416a814e5410"
    sha256 cellar: :any_skip_relocation, ventura:       "cc698cd9a4cb7bfdbb3201bd536f94e32804e2859bf0ee91dade320db3582a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02789863cb082b05977dd7f67095fc5367fa43351628f44056a0d6eb169cd2b7"
  end

  depends_on "go" => :build

  def install
    system "make", "kubeseal", "DIRTY="
    bin.install "kubeseal"
  end

  test do
    # ensure build reports the (git tag) version
    output = shell_output("#{bin}kubeseal --version")
    assert_equal "kubeseal version: v#{version}", output.strip

    # ensure kubeseal can seal secrets
    secretyaml = [
      "apiVersion: v1",
      "kind: Secret",
      "metadata:",
      "  name: mysecret",
      "  namespace: default",
      "type: Opaque",
      "data:",
      "  username: YWRtaW4=",
      "  password: MWYyZDFlMmU2N2Rm",
    ].join("\n") + "\n"
    cert = [
      "-----BEGIN CERTIFICATE-----",
      "MIIErTCCApWgAwIBAgIQKBFEtKBDXcPklduZRLUirTANBgkqhkiG9w0BAQsFADAA",
      "MB4XDTE4MTEyNzE5NTE0NloXDTI4MTEyNDE5NTE0NlowADCCAiIwDQYJKoZIhvcN",
      "AQEBBQADggIPADCCAgoCggIBALff4ul8nqD+5mdaeFOJWzhah8v+AJeXZ2Ko4cBZ",
      "5PCWvbFQKAO+o2GwEZsUHaxP31eeUIAt0LSjxaT9usoXK8QbtwRBV39H6iLI48+",
      "DP2v9AnZgN7G87lyqDufy5IdRyeYh0naTc9C8jWwoG8rDYR85Jxf+M9grLb2yeD",
      "hAj+ziPTBr3t4hleob6pUUNh5I2rnoIT9lrCaRLTOhJqYofL4ld9ikDdCR0h2W9",
      "ZZCb9MnYNohng7KCRWeyPEs+pDs5XiDCn4m4ObL4JJDhS4uIUiY0jstlN74wRul",
      "BZzn3WpjpDSLNa6wTpfo91UplBUDEr9eWWsfGcgAw5iuKM46uWX7sAWQg65CqT3",
      "oR9JMJIRvNKbTEMfXRAIw0Imrox5E9B1uv3tCowFY4zQRNFUnEcCOonyOXGyVP8V",
      "gLMA+2f1vGyFYXjbPyC8dRJZzUf9t+PfhitIU6eNjmeF5s319n0kfiC4e+38Dv",
      "QNuZ9MgUfa5pVcLKtX83Zu6vrNDOJT0iFilWqHqo7BCtfAPX2o2iXDhZDtcIV",
      "AafIu9HIuldEeAmfp7zAkFQEG+boL54kHsrvTljDkxHvl39eJuFqvZVdJAXcCVfO",
      "KyXyAdDk11XVhCyGMu93L7tffsmVVqgVcXUvKupqjag+xDTfRPhHCM1FrDMA7e",
      "ghuLAgMBAAGjIzAhMA4GA1UdDwEBwQEAwIAATAPBgNVHRMBAf8EBTADAQHMA0G",
      "CSqGSIb3DQEBCwUAA4ICAQATIoPga81tw0UQpPsGr+HR7pwKQTIp4zFFnlQJhR8U",
      "Kg1AyxXfOL+tK28xfTnMgKTXIcel+wsUbsseVDamJDZSs4dgwZFDxnV76WhbP67a",
      "XP1wHuu6H9PAtNKV7iGpBL85mg88AlmpPYX5P++Pk5h+i6CenVFPDKwVHDc0vTB",
      "z4yO7MJmSmvGAkjAjmU0s37t3wfWyQpgID8uZmKNbvH8Ie0YfSuHz42HMOtb1SI",
      "5ck8jVpQgJwpfNVAy9fwwdyCdKKEGyGmo8oPYAT5Y9GFZh8dqoqVqATwJqLUeV",
      "OEDxoRV+BXesbpJbJ8tOVtBHzoDU+tjx1jTchf2iWOPByIRQYNBvk25UWNnkdFLy",
      "f9PDrMo6axh+kjQTqrJ4JChL9qHXwSjTshaEcR272xD4vuRX+VMstQqRPwVElRnf",
      "o+MQ5YUiwulFnSykR5zY0U1jGdjywOzxRDLHsPo1WWnOuzfcHarM+YoMDnFzrOzJ",
      "EwP0zIygDpFytgh+Uq+ypKav7CHdAyyeWjDJI8b6gKB3mDB5pF+0KtBV61kbfF",
      "7+dVEtF0wQK+0CUdFtFRv3sk5Ud6wHrvMVTY7I4UcHVBe08DhrNJujHzTjolfXTj",
      "s0IweLRbZLe3m9JLdW6WxylJSUBJhFJGASNwiAm9FwlwryLXzsjNHV8Y6NkEnf",
      "JQ==",
      "-----END CERTIFICATE-----",
    ].join("\n") + "\n"

    File.write("cert.pem", cert)
    pipe_output("#{bin}kubeseal --cert cert.pem", secretyaml)
  end
end