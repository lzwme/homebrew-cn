class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.11.0.tar.gz"
  sha256 "fd1b492d0fc4d0e4930e3b3a547957ccb01898306797b1a1afbc4512eb045566"
  license "MPL-2.0"
  head "https://github.com/inko-lang/inko.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "135a9bc1794ee3afc088ca7f7e5e2647d8c9ba8b32112ca61d10c0277b0432f2"
    sha256 cellar: :any,                 arm64_monterey: "83bdfe0f42745642c79f3584f11119505bddd8b5b743de5f7fa94b40a6914ef1"
    sha256 cellar: :any,                 arm64_big_sur:  "f1062bdae4583a55deda9d80ff8fd850665901ecabf0db248a6487fd5313b7d4"
    sha256 cellar: :any,                 ventura:        "255bf406f901878da903abefc27bed856e4910fc5164a6757a20c3b2fa62e27f"
    sha256 cellar: :any,                 monterey:       "7a5434ead93e9205cb066ae95c61007f0e2024293a09a89701ed7fdf5e3f4a6f"
    sha256 cellar: :any,                 big_sur:        "438c34b8ede0b33edfd552ba4fda45214babdfa78d699bd0ce29565390fd4d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20293924c09ba14723b63f4b7392c7231e57f5a0449e101bef8103ffcbceea8e"
  end

  depends_on "coreutils" => :build
  depends_on "llvm@15" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :sierra

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::STDOUT

      class async Main {
        fn async main {
          STDOUT.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end