class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://ghfast.top/https://github.com/saidutt46/domain-check/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3aa4879e73f9ce503cd8e8387c321e44d977d6d62e4c2b862cdb359ad97dc255"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c63b6957e57105a1933bd479a681787cd2593f045779b63afd62edca383f77eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddd48aac0476dbf692086bcd946f6dea2b918d3f93dce5009ae33d254e2d4aea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bd65a88af4ca9bacf8f52826d560f99823124c440a4d5bb62fa0557b34b7168"
    sha256 cellar: :any_skip_relocation, sonoma:        "f90616693ad8ba537553cdbd1960235bc1d6a269b2548ebd8648ced1a31fa96b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2648b066a1a7c620fba025266431227ba44368a5ef7148d6d8e47ff807fdfbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1652708706d51051d3412c22b204844736b4f0534928ee6128cddd992521751c"
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