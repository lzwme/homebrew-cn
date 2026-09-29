class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://ghfast.top/https://github.com/saidutt46/domain-check/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "762e1a4239e3257a106e31248cefe94bccd8b1ba6e0b9ef504d0493a4488e334"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a51074ca330985c3ee943c2ef7afd718c741e9ff751821c2e843c6ccbdf200c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8eca0fb3a2164c3546511cf948c3a93070fe973103e16b36c06e9d68ec6f51d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07a66b6572371786637c5096330a99e9d5b831361e375406345bc2384bb6dcec"
    sha256 cellar: :any,                 arm64_linux:       "67ac470cf12eec9d76754e70273c1a1df4aaccdf7e94735f0cff16da2b4d1bca"
    sha256 cellar: :any,                 x86_64_linux:      "baf4723e95739a18bb08c0f93ba3cda090a559984c94ba776a90c3d990029725"
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