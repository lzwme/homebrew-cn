class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://ghfast.top/https://github.com/tavianator/bfs/archive/refs/tags/4.1.1.tar.gz"
  sha256 "23f72223733d08393e9a5309c6a38b175e32d9afa65b15517edc316bd02a1f4f"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25aa919670b9e9f2d9b3cfcb01b5e73f574e02cbaa2a544bb8eb2c5b82d9d3b5"
    sha256 cellar: :any,                 arm64_sequoia: "361c1e90ce900bc4279afa7eb0cb6661c22f440e0b4518748740c6c7cccc9660"
    sha256 cellar: :any,                 arm64_sonoma:  "3b3021baefab4fa5b1c3be129710efdc34102ff9cb61e48f921309a43600b7ac"
    sha256 cellar: :any,                 sonoma:        "02abd18d52fd4275b2fbaaf253e36aac8b5526106217369160ac5b5c658ac61d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0940f982cae75976499fab1ee15a9b1013ecb7f1cbd66af5bc6391f6d42631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e61b565bad6ba51814c96b49f483fa6fed47be82224fe415eba7fe03b300ac59"
  end

  depends_on "pkgconf" => :build
  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  fails_with :clang do
    build 1300
  end

  def install
    system "./configure", "--enable-release"
    system "make"
    system "make", "install", "DEST_PREFIX=#{prefix}", "DEST_MANDIR=#{man}"
    bash_completion.install share/"bash-completion/completions/bfs"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -regextype emacs -depth 1").chomp
  end
end