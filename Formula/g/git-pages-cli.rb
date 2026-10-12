class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/releases/download/v1.11.1/git-pages-cli-src.zip"
  sha256 "ddef443f1d8548558e49ac552aa1456f0dbe79f16607bac6154d7721e7c9230b"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9d54e83f5bfb79c84dd3190137f55bc969176411a2310c3d7360909f1324306"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9d54e83f5bfb79c84dd3190137f55bc969176411a2310c3d7360909f1324306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9d54e83f5bfb79c84dd3190137f55bc969176411a2310c3d7360909f1324306"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96c92025745ca8b3bb8c087c19af1bf683caf74da820d4b8aeab33647dcedacd"
    sha256 cellar: :any,                 x86_64_linux:      "06fad7e94c290500194d608f9f9c44951eea1d83fa74c290bf9d1619d85f2d9e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.versionOverride=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end