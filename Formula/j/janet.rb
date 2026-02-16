class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://ghfast.top/https://github.com/janet-lang/janet/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "f35dfe8198ead4aca27415a43f2e16f419f3a4c9666999211a552b196ab0b253"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a5aa8e46c94f32d5dc36d7513783f45e5dd9c6f88fe92491256bf192bca84bb"
    sha256 cellar: :any,                 arm64_sequoia: "b9cdab3d58e9bd73ddc76bba05dd03ddb51612f066e38226d9560a4e88c7f040"
    sha256 cellar: :any,                 arm64_sonoma:  "c887671cf1e762cdc8ae1202b101d9c6d65ed7fdebbbac5118d15d7cbc13606c"
    sha256 cellar: :any,                 sonoma:        "99c273ee1251a7392252bb1051ca1d732c229615e1f0e13a38046d0bdc1780e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07f89626ee4e292e6bd7d645730c35aa83427fcac33797d54560ac8a65a4dfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "416409e008f6e237546aa1baee60f19cd180e61be7f898a10008baaab41c776e"
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