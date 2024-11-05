class Kubeseal < Formula
  desc "Kubernetes controller and tool for one-way encrypted Secrets"
  homepage "https:github.combitnami-labssealed-secrets"
  url "https:github.combitnami-labssealed-secrets.git",
      tag:      "v0.27.2",
      revision: "28ec06b4c7e1a42919baeaeab4ab79d6a610af02"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fdbd6b4b3953cbf7440b1ff783ec87889c8869b63c491be233866e277f2269a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da1f87aa0e16882a4d2f26a6af8363b19d4fca8310c1a837d8aa0931b2f1151e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cddaf27cb5049381d49a539e6ed7228d3a2e562c7113e665579e472bba907ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f5c18b0aa5f5ed986be8fabbc635a86e160eb728c2b07f53af78a1e929433d0"
    sha256 cellar: :any_skip_relocation, ventura:       "c4c16b82340b6d5562a87b7f100cd9549ba50dfca34d3d3078c133bd6f7438de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372aed1924650bee95565fa1e5d22407e8e6aabbbf45b7aaa2b0eca16b0a8d84"
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