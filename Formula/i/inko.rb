class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https:inko-lang.org"
  url "https:releases.inko-lang.org0.17.0.tar.gz"
  sha256 "d97e1b898fd3de946dab5559c587cab0bcf7f3df40a43266d5b9e0a14f03202a"
  license "MPL-2.0"
  head "https:github.cominko-langinko.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d54272ae0638dfabf26a73708365218cec4bfe02248eb628fa4570eac9e69e10"
    sha256 cellar: :any,                 arm64_sonoma:  "d16b0f9c5ddf61d12fed1756537aa712f9b0ba82f5d45dca924e3605611c99c1"
    sha256 cellar: :any,                 arm64_ventura: "768d5f7db84747116d1fc6c59cf1fe3f046f5b4e3ac1fd0bc0fc8806b7f76b6d"
    sha256 cellar: :any,                 sonoma:        "f194d58ffad8d207d24544d78ff0d5c05c471aad34cb1910e3f8102b3d6d9f17"
    sha256 cellar: :any,                 ventura:       "f8deb56f32f1bef8c16b4435a65aea0fda2c70d32ff7df074b1e9bfb3bb30d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ede8a28659804084deaedd7a5936ccb5ad6bb3283ce9ffc6079ea008dc993c4"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ncurses"
  uses_from_macos "ruby", since: :sierra
  uses_from_macos "zlib"

  on_macos do
    depends_on "z3"
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec"gnubin"
    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"hello.inko").write <<~EOS
      import std.stdio (Stdout)

      class async Main {
        fn async main {
          Stdout.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}inko run hello.inko")
  end
end