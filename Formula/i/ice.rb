class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://ghfast.top/https://github.com/zeroc-ice/ice/archive/refs/tags/v3.7.10.tar.gz"
  sha256 "b90e9015ca9124a9eadfdfc49c5fba24d3550c547f166f3c9b2b5914c00fb1df"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "163b12ea66fc9210f121ee9c2f0fc18404d8f660a963d3bf492af0b807eb19d8"
    sha256 cellar: :any,                 arm64_sequoia:  "7c514dfb78c4739a0e3a89fef4c6cb238fa944b43efab26bda3aea20ec4ae47e"
    sha256 cellar: :any,                 arm64_sonoma:   "9e16e4dc54af25f1f87ada450ac1179be3f2ddbdfaf53d75fc242f20dd093721"
    sha256 cellar: :any,                 arm64_ventura:  "c13e1bd19804740b88a1a91acb548a66a4407bb234c74423bf0fa5a4c529b59c"
    sha256 cellar: :any,                 arm64_monterey: "0193902362ba7001f9ada681d417b2ff2178a259e1742a1ef7b40a13a0c1659f"
    sha256 cellar: :any,                 sonoma:         "7f5e821c0f5341f106eb7ac794cc28212fff4cb1ea7c1bc4a9b4be0f9045453f"
    sha256 cellar: :any,                 ventura:        "f51b98196d1bbd54ebc2f5fd0afc4ca79581109d94546741cf60abb6c7a5f32f"
    sha256 cellar: :any,                 monterey:       "0cddb56c9be86ab8f4c9741f3ef2b4b1cebd4893692f8ddd06085c4e6bd82512"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "303296e9ae326b721e3cc46e5d1d714ae03c74ca4b0504539d65c9e1517e9f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52ec26319cdc6a02479ca493939ca965d97fde730b6d2f35eb151f55b0735e2a"
  end

  depends_on "lmdb"
  depends_on "mcpp"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    extra_cxxflags = []

    # Workaround for Xcode 16 (LLVM 17) Clang bug that causes:
    # include/Ice/OutgoingAsync.h: error: declaration shadows a local variable [-Werror,-Wshadow-uncaptured-local]
    # Ref: https://github.com/llvm/llvm-project/issues/81307
    # Ref: https://github.com/llvm/llvm-project/issues/71976
    extra_cxxflags << "-Wno-shadow-uncaptured-local" if DevelopmentTools.clang_build_version >= 1600

    # Workaround for macOS 26 SDK
    extra_cxxflags << "-Wno-deprecated-declarations" if DevelopmentTools.clang_build_version >= 1700

    # Workaround for Xcode 26 (Clang 17)
    extra_cxxflags << "-Wno-reserved-user-defined-literal" if DevelopmentTools.clang_build_version >= 1700

    unless extra_cxxflags.empty?
      inreplace "config/Make.rules.Darwin", "-Wdocumentation ", "\\0#{extra_cxxflags.join(" ")} "
    end

    args = [
      "prefix=#{prefix}",
      "V=1",
      "USR_DIR_INSTALL=yes", # ensure slice and man files are installed to share
      "MCPP_HOME=#{Formula["mcpp"].opt_prefix}",
      "LMDB_HOME=#{Formula["lmdb"].opt_prefix}",
      "CONFIGS=shared cpp11-shared xcodesdk cpp11-xcodesdk",
      "PLATFORMS=all",
      "SKIP=slice2confluence",
      "LANGUAGES=cpp",
    ]

    # Fails with Xcode < 12.5
    inreplace "cpp/include/Ice/Object.h", /^#.+"-Wdeprecated-copy-dtor"+/, "" if OS.mac? && MacOS.version <= :catalina

    system "make", "install", *args

    # We install these binaries to libexec because they conflict with those
    # installed along with the ice packages from PyPI, RubyGems and npm.
    (libexec/"bin").mkpath
    %w[slice2py slice2rb slice2js].each do |r|
      mv bin/r, libexec/"bin"
    end
  end

  def caveats
    <<~EOS
      slice2py, slice2js and slice2rb were installed in:

        #{opt_libexec}/bin

      You may wish to add this directory to your PATH.
    EOS
  end

  test do
    (testpath/"Hello.ice").write <<~EOS
      module Test
      {
          interface Hello
          {
              void sayHello();
          }
      }
    EOS

    port = free_port

    (testpath/"Test.cpp").write <<~CPP
      #include <Ice/Ice.h>
      #include <Hello.h>

      class HelloI : public Test::Hello
      {
      public:
        virtual void sayHello(const Ice::Current&) override {}
      };

      int main(int argc, char* argv[])
      {
        Ice::CommunicatorHolder ich(argc, argv);
        auto adapter = ich->createObjectAdapterWithEndpoints("Hello", "default -h 127.0.0.1 -p #{port}");
        adapter->add(std::make_shared<HelloI>(), Ice::stringToIdentity("hello"));
        adapter->activate();
        return 0;
      }
    CPP

    system bin/"slice2cpp", "Hello.ice"
    system ENV.cxx, "-DICE_CPP11_MAPPING", "-std=c++11", "-c", "-I#{include}", "-I.", "Hello.cpp"
    system ENV.cxx, "-DICE_CPP11_MAPPING", "-std=c++11", "-c", "-I#{include}", "-I.", "Test.cpp"
    system ENV.cxx, "-L#{lib}", "-o", "test", "Test.o", "Hello.o", "-lIce++11", "-pthread"
    system "./test"
  end
end