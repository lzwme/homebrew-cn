class Kubeseal < Formula
  desc "Kubernetes controller and tool for one-way encrypted Secrets"
  homepage "https:github.combitnami-labssealed-secrets"
  url "https:github.combitnami-labssealed-secrets.git",
      tag:      "v0.27.1",
      revision: "2d119da247b0b433c4490da7163f869a9cf8aef3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ec10856b55d70871ed4b87181a857716b51e89265725764b16442144e10611d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0006dcbccd5fadc7533560f256e14f9b727598ce138810440f59e456b2ec05e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a446b13a00ba466fdec5d5934d734c328c5d2cfb1170d3264f484ff11c30f6a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9bca11ad770bdf1e079e038db74fa2a9f326325ffa9edb4f337f8d9ad5c4a24"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dbd45948dfcd8310f0b7d9acf2d4bd2534ec0eb293418cd2692ae7a16dd315c"
    sha256 cellar: :any_skip_relocation, ventura:        "8efc96792c1b46cc81c8950bdeb983c1a8feb2fec7ecff0868983f73d01128a9"
    sha256 cellar: :any_skip_relocation, monterey:       "7cb068678c9baffe3b341289a82fdcbd7c266d0f37d7fa82d41909e36684802a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b9063c1531ab9b6ce6472935f2f77dbc7d5f5fb887f6aee127e0cae3a404bab"
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