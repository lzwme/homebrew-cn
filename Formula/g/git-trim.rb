class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim.git",
      tag:      "v0.4.4",
      revision: "1f39d85ddb242e9933fba9faaecd6f423f2b6a5b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f230f99015946e53ff857649b92fc82ebdc01d53aabb1698379a6428056a304"
    sha256 cellar: :any,                 arm64_monterey: "a39f49254342159071cbb88d3f3b8e97f189f5333502d185be152c73fe9c5770"
    sha256 cellar: :any,                 arm64_big_sur:  "0f3c73e37431403348e7ac496b3b39671366a576d61e75315d0e2f6667000404"
    sha256 cellar: :any,                 ventura:        "69a202e87bbe253c69c6cdcf65faf14e9523a8419c65ddd74eacc209dd432a94"
    sha256 cellar: :any,                 monterey:       "164e873f61a2afa6c661821d77480ecf94d7c3e4d77da26335925af31628722b"
    sha256 cellar: :any,                 big_sur:        "0e8c7d52f14301a786bfe5cce167310955f11da5cce33c780f6dee5da1299c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4663a90075b39aa34a60e0b5c097bb69b1820b9a72b1d47c54562fa9e08288de"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end