class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://ghfast.top/https://github.com/janet-lang/janet/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "a93f1d3ba220e487e2fd95b786602eb786c4972e356cec2e19c5d75289edc52f"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13c05dafba288275617c921cc564c8e6824f6baa3dba34888b06c2f29075cfec"
    sha256 cellar: :any,                 arm64_sequoia: "b22c0f782b155705dc444a2ff957194e7a6880e400807b40418a1fbf024f71a9"
    sha256 cellar: :any,                 arm64_sonoma:  "8feeb845715d4418e68c5bb8b4a59005805b432e66bd89133ff1446e37534701"
    sha256 cellar: :any,                 sonoma:        "a4886c409affd40815a443dabef86304e457941fa72583f38412c6454ae096a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87c4f78014b25f29c493018dd04989a73fc5feb4af30b552eb58b2f21a7a1525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8debc2ce440144e0a12ecb026e92c92b89fa20b1d2c2b5357674b2657ccb3b"
  end

  resource "jpm" do
    url "https://ghfast.top/https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def syspath
    HOMEBREW_PREFIX/"lib/janet"
  end

  def install
    # Replace lines in the Makefile that attempt to create the `syspath`
    # directory (which is a directory outside the sandbox).
    inreplace "Makefile", /^.*?\bmkdir\b.*?\$\(JANET_PATH\).*?$/, "#"

    ENV["PREFIX"] = prefix
    ENV["JANET_BUILD"] = "\\\"homebrew\\\""
    ENV["JANET_PATH"] = syspath

    system "make"
    system "make", "install"
  end

  def post_install
    mkdir_p syspath unless syspath.exist?

    resource("jpm").stage do
      ENV["PREFIX"] = prefix
      ENV["JANET_BINPATH"] = HOMEBREW_PREFIX/"bin"
      ENV["JANET_HEADERPATH"] = HOMEBREW_PREFIX/"include/janet"
      ENV["JANET_LIBPATH"] = HOMEBREW_PREFIX/"lib"
      ENV["JANET_MANPATH"] = HOMEBREW_PREFIX/"share/man/man1"
      ENV["JANET_MODPATH"] = syspath
      system bin/"janet", "bootstrap.janet"
    end
  end

  def caveats
    <<~EOS
      When uninstalling Janet, please delete the following manually:
      - #{HOMEBREW_PREFIX}/lib/janet
      - #{HOMEBREW_PREFIX}/bin/jpm
      - #{HOMEBREW_PREFIX}/share/man/man1/jpm.1
    EOS
  end

  test do
    janet = bin/"janet"
    jpm = HOMEBREW_PREFIX/"bin/jpm"
    assert_equal "12", shell_output("#{janet} -e '(print (+ 5 7))'").strip
    assert_path_exists jpm, "jpm must exist"
    assert_predicate jpm, :executable?, "jpm must be executable"
    assert_match syspath.to_s, shell_output("#{jpm} show-paths")
  end
end