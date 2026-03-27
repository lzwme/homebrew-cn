class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "b8af5a460dcfc7382b4584d74347321687e83546341742a9e5c9676305ce190b"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f9a1b91f848d3e4b347df1ee5f19565b282673cced35fd2e19fd69af6cc7e43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1172600f0ecb2da944e46dd3f82c2aa38020d3a0820159a2400f23f0aaca06dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8742b21ad96ce410fc9d5130c8d4937f289474c26cdd32d9a313f0f67480f5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a890be5e5d818565f462e2b1dc6f5bf005643f75479cfb4b75bc6d7581805da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7508bfc91363bb7c0eef4644b6bd21893172d472d3d218252264d7ae28deb5eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc4b583d1644943034f60378b13908e56d32ae429b24c92a64c192bf9c26ed5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end