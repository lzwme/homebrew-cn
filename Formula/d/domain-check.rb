class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://ghfast.top/https://github.com/saidutt46/domain-check/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "50bd1faeca33b9cb1b711fff890064ca1501de898295b72aa381275e883e9846"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c43e711c32886f71e6d59816d5866e57d8a848f112d23fc391b36e323cd27c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9494d571cc9c47fb5ae80f20c96f24126557c48eb3a2fe10bc8c5769cf900f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb12439742ba2ae35692dc81725fda2281b9e618759c09c417b35561e5f9e324"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6b2b105f40b46861be21195aa71244cf3352f69966c22d04e604f09dd580d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d32705431e99b041db26c283ba984191ce55d7932eecefb86d44679e2423a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bedc82f976fe30bdba8854b4c14f7b575f5bec7bf6437a4be54caedd484e1a24"
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