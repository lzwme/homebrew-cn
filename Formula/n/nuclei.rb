class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://ghfast.top/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "0f57ec39dd1cb67bd5324c6b0e4e1783e0bd3a3f5f0e65b6dedae145fc6865fe"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ceb25a8eb9ad6a3c9ba53dfe8da5a3e5debcf35ccfa45fca774806a5f5c8441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ddc239db536ec4fa50eff04fc5dd4240551b1156e08defaa583f2d5c001d493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71eebf6d4ef54bcfd454cbb3a99cb067a3640f3071638e0eaedef6b8be79be7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bff4fe593c8e3ccf5c767ea69b42965468a019f4fd69bf4a4c2b5edf0b38f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d748e0242166d0ee5d774a0127e5dd5f63da4136dd213679bd3ad93d92d2f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99320c04a2caab81b7ed9b13bce68cb068f8177316a0cbe1fdebb6c100989482"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end