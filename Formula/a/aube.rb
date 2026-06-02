class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "e32cf8cfa4f0f9450db399eb0c4f0391b911ae4fac7cdf8819073b25781e893c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6051b7282c28ed83c4016b3f8035025b0b105562440405c1afa050fe6667fd2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3f8262bb2ad66d073f1f142a323b0a6402c16e35dc077526fdf57a1909fde51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7130dfa5a269a086cdfdf1c383b95cc97d8a9ffd268a7c345159748a23502d7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b0bdd0d36f08e4956d8b0ba4e602b6858743aece4daff71d484cde91c643fe9"
    sha256 cellar: :any,                 arm64_linux:   "deff52cc4f74f15a469299bdcb8da11862d5c3539675e9a56daf85a656063ff9"
    sha256 cellar: :any,                 x86_64_linux:  "0f8d34c22f1d48752013c0c2cd7234dd948b5bfdf1378a93e1e0a5e639ee46df"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end