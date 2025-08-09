class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://ghfast.top/https://github.com/polyml/polyml/archive/refs/tags/v5.9.2.tar.gz"
  sha256 "5cf5f77767568c25cf880acc2d0a32ee3d399e935475ab1626e8192fc3b07390"
  license "LGPL-2.1-or-later"
  head "https://github.com/polyml/polyml.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "937771b69a2cbe3e80edc278897b1e1b72b8976c06febc1cba609069e1bd16e6"
    sha256 arm64_sonoma:  "547f2f271d7190f9f5a9d7bcd0f128ee5955981ac05817db081e3e351b7a9ee1"
    sha256 arm64_ventura: "55de2b3a7d090a5a48d28c4e17c1df3953426c530ff4abd36bbd3b2aee08fe8d"
    sha256 sonoma:        "ef8d624eaa7afe576b0e515dc44d073b4c1f94687a6d74e7dcfb01f9a3bc7723"
    sha256 ventura:       "0e6b440ca663bf2381929c8221981d42a8512358bc72ee793011dd46ee361c9d"
    sha256 arm64_linux:   "3788ade9f88c53eba01afad3312af68ff99d7214c2537515a9fce47567266e99"
    sha256 x86_64_linux:  "05b1f452df38e1aec8f76a6c625ab764ecc3dec75ee0f0b26f608157094c0a20"
  end

  def install
    # Use ld_classic to work around 'ld: LINKEDIT overlap of start of LINKEDIT and symbol table'
    # Issue ref: https://github.com/polyml/polyml/issues/194
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    args = ["--disable-silent-rules"]
    # Disable native code generation on CI ARM macOS to work around:
    # Bus error: 10 ./polyimport ./bootstrap/bootstrap64.txt -I . < ./bootstrap/Stage1.sml
    # Issue ref: https://github.com/polyml/polyml/issues/199
    args << "--disable-native-codegeneration" if ENV["HOMEBREW_GITHUB_ACTIONS"] && OS.mac? && Hardware::CPU.arm?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    on_macos do
      on_arm do
        <<~EOS
          The `polyml` bottle was built with native code generator disabled due to
          the build failure seen in https://github.com/polyml/polyml/issues/199.
        EOS
      end
    end
  end

  test do
    (testpath/"hello.ml").write <<~EOS
      let
        fun concatWithSpace(a,b) = a ^ " " ^ b
      in
        TextIO.print(concatWithSpace("Hello", "World"))
      end
    EOS
    assert_match "Hello World", shell_output("#{bin}/poly --script hello.ml")
  end
end