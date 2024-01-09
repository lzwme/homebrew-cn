class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https:github.comzmapzlint"
  url "https:github.comzmapzlint.git",
      tag:      "v3.6.0",
      revision: "be8dd6a629e36c9a9a34aeb7b34ed06327151ce3"
  license "Apache-2.0"
  head "https:github.comzmapzlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "882cc963775dd75f2627423e2876c5fd4faf981e6541dcd8cd65624b2b78d1e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa1905b7256fac501a89bbfd0624788ae4733bd0c0f58ace07751d8d1e1c4a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7e30f06b3a9a9bed92b46318b2d80d9c355666f133d89d355c778312dade479"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6baa5e327fb98ffeba4977cfbd35dbee0d770322bed4fafa358c43bad6fe84e"
    sha256 cellar: :any_skip_relocation, ventura:        "98961db521cda713dde45b82e595d0f68f8582dfa53add9275771a95bb648267"
    sha256 cellar: :any_skip_relocation, monterey:       "c971cda4fa10b9325b5f2f5a33def8427392fff75ff45d37c555fe29816f7172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27bb6434b06354772c344b1ea6f5a7ee2399d708602e0cc28e2c02ce40505a31"
  end

  depends_on "go" => :build

  def install
    system "make", "--directory=v3", "GIT_VERSION=v#{version}", "zlint"
    bin.install "v3zlint"
  end

  test do
    assert_match "ZLint version v#{version}",
      shell_output("#{bin}zlint -version")

    (testpath"cert.pem").write <<~EOS
      -----BEGIN CERTIFICATE-----
      MIIB3jCCAWSgAwIBAgIUU3hxzxSDV5V1DeRyZjgzdPKatBEwCgYIKoZIzj0EAwMw
      HjEcMBoGA1UEAwwTaG9tZWJyZXctemxpbnQtdGVzdDAeFw0yMjAxMDEwMDAwMDBa
      Fw0yMzAxMDEwMDAwMDBaMB4xHDAaBgNVBAMME2hvbWVicmV3LXpsaW50LXRlc3Qw
      djAQBgcqhkjOPQIBBgUrgQQAIgNiAASn3DDorzrDQiWnnXv0uS722si9zx1HK6Va
      CXQpHm8t1SmMEYdVIU4j5UzbVKpoMIkk9twC3AiDUVZwdBNL2rqO8smZiKOh0Tz
      BnRf8OBu55C7fsCHRayljjW0IpyZCjCjYzBhMB0GA1UdDgQWBBRIDxULqVXg4e4Z
      +3QzKRG4UpfiFjAfBgNVHSMEGDAWgBRIDxULqVXg4e4Z+3QzKRG4UpfiFjAPBgNV
      HRMBAf8EBTADAQHMA4GA1UdDwEBwQEAwIBhjAKBggqhkjOPQQDAwNoADBlAjBO
      c1zwDbnya5VkmlROFco5TpcZM7w1L4eRFdJq7rZF5udqVuy4vtu0dJaazwiMusC
      MQDEMciPyBdrKwnJilT2kVwIMdMmxAjcmV048Ai0CImT5iRERKdBa7QeydMcJo3Z
      7zs=
      -----END CERTIFICATE-----
    EOS

    output = shell_output("#{bin}zlint -longSummary cert.pem")
    %w[
      e_ca_organization_name_missing
      e_ca_country_name_missing
    ].each do |err|
      assert_match err, output
    end
  end
end