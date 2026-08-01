class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://ghfast.top/https://github.com/kunchenguid/treehouse/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "3072d5263da14e3034c40812cee65b0e74e94aa195c714132f89ba5777e0d8ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2211056155d2851a0fd33ac9efb61b441339d1467c5e5af067e53e1d2bd7bce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bfc2c34ecd722980b0b67e51b90913856c08629bc906b340c16af4f4dc8d546"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95018a04d55269281f859d093dc1b1fdc35eace238838dec3c5d8b799a0e43d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b59e9a25d56d53f85ede1e3c1b0aa3c992fc9295d610c419ada24017bd5b477d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5a4fa7cb28f1e2a7ac279ef601524eb020b7789436740d63e266caaf3b5785"
    sha256 cellar: :any,                 x86_64_linux:  "bfa1b02c5039b7dfbb43d202e4f854bfc0b46cccf604d6b63e53c32a37bf2c66"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    system "git", "init", "--quiet"
    system bin/"treehouse", "init"
    assert_path_exists testpath/"treehouse.toml"
    assert_match "max_trees", (testpath/"treehouse.toml").read
  end
end