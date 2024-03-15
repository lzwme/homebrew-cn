class Kubeseal < Formula
  desc "Kubernetes controller and tool for one-way encrypted Secrets"
  homepage "https:github.combitnami-labssealed-secrets"
  url "https:github.combitnami-labssealed-secrets.git",
      tag:      "v0.26.1",
      revision: "536250f5be8f21413b77629d5480265678d8c95f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fc2f87c422fcb7bf8344f1cb7794bf174e466dd9d35a7b5f0838f678e9cb846"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58d5371f00b36533a6f6a3dd156fb2c67832fe325f2185dc6c9a5a1a4c2ba784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35f41dcb2a97005a4bfc6c751d5a7ab31891efe920c64556aaba77fd9838f14a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3b2aa0df25c7db5274d5647fc56862c7bec48892f685dacfbd6bac93f265da5"
    sha256 cellar: :any_skip_relocation, ventura:        "5f9b9740fddc2eec6c3d9231150ee073c764aa2d0c3b2e2ef87428c357a39812"
    sha256 cellar: :any_skip_relocation, monterey:       "797c81f6a7049c71a4ad1ce139c2ded9d7ba2eb7557fe8053ecdc3333db0c318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20fd2890dccb5fe52a048cd06852a98d61740ec0bb2c379c83b1d46609b6fdc3"
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