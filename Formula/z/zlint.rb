class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https:github.comzmapzlint"
  url "https:github.comzmapzlint.git",
      tag:      "v3.5.0",
      revision: "45e8dff6fe0d2a6989366a3dbd44713c360afc8f"
  license "Apache-2.0"
  head "https:github.comzmapzlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6e8676ab7323d994d3dfb7ed10811e76b0ee1dbb8356d5faae44e737f2ddbfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c6e2db91078b648c70b65e045f265291a93d1936c35bd5f50de67d6ffed7e67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "870a9b3d865c07dcee5df61c933bcc06964c7f67e98888472b70faf3880efbbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "487c8eab86c4ae89f047d6ebcea40f4707fdd0f93bf0b724a51a6d2f1a31a10e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e3fe54543c0b1b19253072394314950187ca3744faacb55c05dc835c928a9db"
    sha256 cellar: :any_skip_relocation, ventura:        "c3e18791e097ac32f17e9bd87ec0d92932ecf9465a1c6be96a38c2fe9a3d1b56"
    sha256 cellar: :any_skip_relocation, monterey:       "4cce97370e576d5aa6d83d20b1a09281a17b47f6b2f7010d58f69ac7d0d98b4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "44f78c1721863740ea49fff58a01230f743d2adbe7d6d9afa21acb287c8ad1ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff883e8663c390615278f11e60038a814ee3143cdff144f4789ba47de7257124"
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