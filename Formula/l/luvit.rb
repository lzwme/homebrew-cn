class Luvit < Formula
  desc "Asynchronous IO for Lua"
  homepage "https:luvit.io"
  url "https:github.comluvitluvitarchiverefstags2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 2
  head "https:github.comluvitluvit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "f004efa20e48708ea7d0a1ea8bfa25bbe3d799ee20984e44f961021364d1dd92"
    sha256 cellar: :any,                 arm64_sonoma:  "cb68897cf4876b88d1d6f4145fc9ede06ef04f4b882c7eff6a9ca8a10e0eb668"
    sha256 cellar: :any,                 arm64_ventura: "7cd6942821d45baa652c413d10d4ad521828d0a86ee581f0f72ff06098491c27"
    sha256 cellar: :any,                 sonoma:        "6f261a667091381e962a5ff45a4080328c111bfe5883ec9d988b08b4eefaa8e5"
    sha256 cellar: :any,                 ventura:       "c18b8fc2393a68b9b37f5ad5676fd619cca659348fb16938574a0a3b2731ce91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39109c056556f13c412c554fd1b421812b32e6d2bd01c4e103d71188612c21e9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libuv"
  depends_on "luajit"
  # TODO: depends_on "luv"
  depends_on "openssl@3"
  depends_on "pcre"

  conflicts_with "lit", because: "both install `lit` binaries"

  # To update this resource, check LIT_VERSION in the Makefile:
  # https:github.comluvitluvitblob#{version}Makefile
  resource "lit" do
    url "https:github.comluvitlit.git",
        tag:      "3.8.5",
        revision: "84fc5d729f1088b3b93bc9a55d1f7a245bca861d"

    livecheck do
      url "https:raw.githubusercontent.comluvitluvit#{LATEST_VERSION}Makefile"
      regex(LIT_VERSION=["']?(\d+(?:\.\d+)+)["']?$i)
    end
  end

  # To update this resource, check LUVI_VERSION in
  # https:github.comluvitlitraw$(LIT_VERSION)get-lit.sh
  resource "luvi" do
    url "https:github.comluvitluvi.git",
        tag:      "v2.12.0",
        revision: "5d1052f11e813ff9edc3ec75b5282b3e6cb0f3bf"

    livecheck do
      url "https:raw.githubusercontent.comluvitluvit#{LATEST_VERSION}Makefile"
      regex(LIT_VERSION=["']?(\d+(?:\.\d+)+)["']?$i)
      strategy :page_match do |page, regex|
        lit_version = page[regex, 1]
        next if lit_version.blank?

        get_lit_page = Homebrew::Livecheck::Strategy.page_content(
          "https:raw.githubusercontent.comluvitlit#{lit_version}get-lit.sh",
        )
        next if get_lit_page[:content].blank?

        get_lit_page[:content][LUVI_VERSION:-v?(\d+(?:\.\d+)+)i, 1]
      end
    end

    # Remove outdated linker flags that break the ARM build.
    # https:github.comluvitluvipull261
    patch do
      url "https:github.comluvitluvicommitb2e501deb407c44a9a3e7f4d8e4b5dc500e7a196.patch?full_index=1"
      sha256 "be3315f7cf8a9e43f1db39d0ef55698f09e871bea0f508774d0135c6375f4291"
    end
  end

  # Needed for OpenSSL 3 support. Remove when the `luvi`
  # resource has a new enough version as a submodule.
  resource "lua-openssl" do
    url "https:github.comzhaozglua-opensslreleasesdownload0.8.3-1openssl-0.8.3-1.tar.gz"
    sha256 "d8c50601cb0a04e2dfbd8d8e57f4cf16a4fe59bdca8036deb8bc26f700f2eb8c"
  end

  def install
    if DevelopmentTools.clang_build_version >= 1500
      # Work around build error in current `lua-openssl` resource with newer Clang
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types"
      # Use ld_classic to work around 'ld: multiple errors: LINKEDIT overlap of start of
      # LINKEDIT and symbol table in '...jitted_tmpsrclualuvibundle.lua_luvi_generated.o'
      ENV.append "LDFLAGS", "-Wl,-ld_classic"
    end

    ENV["PREFIX"] = prefix
    luajit = Formula["luajit"]

    resource("luvi").stage do
      # Build scripts set LUA_PATH before invoking LuaJIT, but that causes errors.
      # Reported at https:github.comluvitluviissues242
      inreplace "cmakeModulesLuaJITAddExecutable.cmake",
                "COMMAND \"LUA_PATH=${LUA_PATH}\" luajit", "COMMAND luajit"

      # Build scripts double the prefix of this directory, so we set it manually.
      # Reported in the issue linked above.
      ENV["LPEGLIB_DIR"] = "depslpeg"

      rm_r "depslua-openssl"
      Pathname("depslua-openssl").install resource("lua-openssl")

      # Build the bundled `luv` as `luvi` is not compatible with newer version.
      # We cannot use `-DWithSharedLibluv=OFF` as it will bundle `luajit` too.
      # TODO: Restore brew `luv` once support is available
      system "cmake", "-S", "depsluv", "-B", "build_luv",
                      "-DBUILD_MODULE=ON",
                      "-DBUILD_SHARED_LIBS=ON",
                      "-DBUILD_STATIC_LIBS=OFF",
                      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                      "-DLUA_BUILD_TYPE=System",
                      "-DWITH_LUA_ENGINE=LuaJIT",
                      "-DWITH_SHARED_LIBUV=ON",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build_luv"
      system "cmake", "--install", "build_luv"

      # CMake flags adapted from
      # https:github.comluvitluviblob#{luvi_version}Makefile#L73-L74
      luvi_args = %W[
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        -DWithOpenSSL=ON
        -DWithSharedOpenSSL=ON
        -DWithPCRE=ON
        -DWithLPEG=ON
        -DWithSharedPCRE=ON
        -DWithSharedLibluv=ON
        -DLIBLUV_INCLUDE_DIR=#{libexec}includeluv
        -DLIBLUV_LIBRARIES=#{libexec}lib#{shared_library("libluv")}
        -DLUAJIT_INCLUDE_DIR=#{luajit.opt_include}luajit-2.1
        -DLUAJIT_LIBRARIES=#{luajit.opt_libshared_library("libluajit")}
      ]

      system "cmake", "-S", ".", "-B", "build", *luvi_args, *std_cmake_args
      system "cmake", "--build", "build"
      buildpath.install "buildluvi"
    end

    resource("lit").stage do
      system buildpath"luvi", ".", "--", "make", ".", buildpath"lit", buildpath"luvi"
    end

    system "make", "install"
  end

  test do
    assert_equal "Hello World\n", shell_output("#{bin}luvit -e 'print(\"Hello World\")'")
  end
end