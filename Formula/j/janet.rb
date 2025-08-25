class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://ghfast.top/https://github.com/janet-lang/janet/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "0f7ea778ac69d019d2489a35ff9f195c99b5e6110c4c7acff3a9ff49a085f010"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f8d5f03d3c2fe1279e48ff4364c8c2655780b4a079934b94925cb834408fc63"
    sha256 cellar: :any,                 arm64_sonoma:  "fa808bd73ebae76e372c39df400951e1122a4ef60a5a56b8e9d62dc806a834e6"
    sha256 cellar: :any,                 arm64_ventura: "7500a77b4ac4f87ba9d4bec89ce4a15d6b767d091a869158113b2e4a62a9b5a7"
    sha256 cellar: :any,                 sonoma:        "8b3229c5a616c895cf8a6e9420b0b93173535cc0fd57f83fc1b766bf78b69d8b"
    sha256 cellar: :any,                 ventura:       "7e6a5629d67ad11018e783adaed8cdedb229d2b495f5a7aebcbd4a89634d4de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9f27dca9f0ebbd5f5bdc92ec91fcee346921e2a3616b94cb8c1453dffa14941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dc315aef94f7d740bf4272d531dafd4499cd1dc848058f5e871b2ece969ff86"
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