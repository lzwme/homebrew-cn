class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https:www.polyml.org"
  url "https:github.compolymlpolymlarchiverefstagsv5.9.1.tar.gz"
  sha256 "52f56a57a4f308f79446d479e744312195b298aa65181893bce2dfc023a3663c"
  license "LGPL-2.1-or-later"
  head "https:github.compolymlpolyml.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "8da7733920403e84fc73e04e2ba73e163630f063daf01d325f777c21ef2faf4c"
    sha256 arm64_ventura:  "e747d6bb96b8aaa374e27d1bb85cfa599f136ab1cfeecbdfffecc01e9dd0326f"
    sha256 arm64_monterey: "92714106cbec11b63c34e38e358e9df4702ba7db81142fc8b6ba80d6e8f36c64"
    sha256 sonoma:         "09a1a0630dadbaca774010a8bf8a017025aeea595f3bf2f1cafbe4a9bdc55431"
    sha256 ventura:        "08a8aea9356cf8fbc35a863668dd554ba4f7196176969f9a95e8217279747e7b"
    sha256 monterey:       "9a8ef34cc09cbbd5871f0de8167a63aa80e7ac476f3169e6c2726b28ef5b9db2"
    sha256 x86_64_linux:   "2c629afd3ff1ad92cdbc78d7b3f638747e4851f8011e1393498aada95c3f452b"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Use ld_classic to work around 'ld: LINKEDIT overlap of start of LINKEDIT and symbol table'
    # Issue ref: https:github.compolymlpolymlissues194
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    args = ["--disable-silent-rules"]
    # Disable native code generation on CI ARM macOS to work around:
    # Bus error: 10 .polyimport .bootstrapbootstrap64.txt -I . < .bootstrapStage1.sml
    # Issue ref: https:github.compolymlpolymlissues199
    args << "--disable-native-codegeneration" if ENV["HOMEBREW_GITHUB_ACTIONS"] && OS.mac? && Hardware::CPU.arm?

    system ".configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    on_macos do
      on_arm do
        <<~EOS
          The `polyml` bottle was built with native code generator disabled due to
          the build failure seen in https:github.compolymlpolymlissues199.
        EOS
      end
    end
  end

  test do
    (testpath"hello.ml").write <<~EOS
      let
        fun concatWithSpace(a,b) = a ^ " " ^ b
      in
        TextIO.print(concatWithSpace("Hello", "World"))
      end
    EOS
    assert_match "Hello World", shell_output("#{bin}poly --script hello.ml")
  end
end