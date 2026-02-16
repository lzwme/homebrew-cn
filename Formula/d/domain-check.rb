class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://ghfast.top/https://github.com/saidutt46/domain-check/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e4e96785d60bbe89a573a6bee5012cb4a57b8f7263fe7e4ab034796ba2a7f320"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88bf667678066152ed0a1e52f86c9cde094de1d4ea8a34b086e2ecc628c1eea2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f6ee51865b974ac664ec2a827e692b8c77cb2ec240d779e91c9b5046625efda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52357c092f379bafb39d6428d454415fb64c5595511b50eb2da7f265c22545ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fe41fd2bc8defa15457cda4d4d6fc3e574c42b41a806c22fe4f295e8ffd1312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a47b8dcfb9c75f20195357aefcdd7cd4f07872d154451d55df6c1b417aad064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74058bff3b348ae189486d79d213be36a2ee725f3e39571d4dd5f52618f7992c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "domain-check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/domain-check --version")

    output = shell_output("#{bin}/domain-check example.com")
    assert_match "example.com TAKEN", output

    output = shell_output("#{bin}/domain-check invalid_domain 2>&1", 1)
    assert_match "Error: No valid domains found to check", output
  end
end