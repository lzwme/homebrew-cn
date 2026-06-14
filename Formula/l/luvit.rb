class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://ghfast.top/https://github.com/luvit/luvit/archive/refs/tags/2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 12
  head "https://github.com/luvit/luvit.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "72c0c0cf3b708c9f0142bdc9d7f505c0991f16cd2d1a5ef704eba6368f5f1fce"
    sha256 cellar: :any, arm64_sequoia: "c97d90813403cbc563de3ff67a738748dbc19e0463536e80c625a1762b8a758c"
    sha256 cellar: :any, arm64_sonoma:  "1183890793f6bd7fa78356e396aaee22d3be75c7705100479699241a80a8f105"
    sha256 cellar: :any, sonoma:        "c72500c911d7fed6b1bee39d173611657b5c4ba40cb214e3dba6569580f5d991"
    sha256 cellar: :any, arm64_linux:   "7e79e66578e75d43a61082ec8dccd3e2fa55d27bf9b04f694b9b574624802c80"
    sha256 cellar: :any, x86_64_linux:  "f9e2ba4fcc1edb067d99021cd42018c5f6f933347aa1bdac5a8d4e6de397c072"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libuv"
  depends_on "luajit"
  # TODO: depends_on "luv"
  depends_on "openssl@3"
  depends_on "pcre2"

  conflicts_with "lit", because: "both install `lit` binaries"

  # To update this resource, check LIT_VERSION in the Makefile:
  # https://github.com/luvit/luvit/blob/#{version}/Makefile
  resource "lit" do
    url "https://github.com/luvit/lit.git",
        tag:      "3.8.5",
        revision: "84fc5d729f1088b3b93bc9a55d1f7a245bca861d"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/luvit/luvit/#{LATEST_VERSION}/Makefile"
      regex(/LIT_VERSION=["']?(\d+(?:\.\d+)+)["']?$/i)
    end
  end

  # To update this resource, check LUVI_VERSION in
  # https://github.com/luvit/lit/raw/$(LIT_VERSION)/get-lit.sh
  # NOTE: Moved up to 2.15.0 for pcre2 and openssl@3 support
  resource "luvi" do
    url "https://ghfast.top/https://github.com/luvit/luvi/releases/download/v2.15.0/luvi-source.tar.gz"
    sha256 "91f40fb6421888c2ee403de80248250c234f3bfb6dd1edbbc9188a89e4b9708a"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/luvit/luvit/#{LATEST_VERSION}/Makefile"
      regex(/LIT_VERSION=["']?(\d+(?:\.\d+)+)["']?$/i)
      strategy :page_match do |page, regex|
        lit_version = page[regex, 1]
        next if lit_version.blank?

        get_lit_page = Homebrew::Livecheck::Strategy.page_content(
          "https://ghfast.top/https://raw.githubusercontent.com/luvit/lit/#{lit_version}/get-lit.sh",
        )
        next if get_lit_page[:content].blank?

        get_lit_page[:content][/LUVI_VERSION:-v?(\d+(?:\.\d+)+)/i, 1]
      end
    end
  end

  def install
    ENV["PREFIX"] = prefix
    luajit = Formula["luajit"]

    resource("luvi").stage do
      # Build the bundled `luv` as `luvi` is not compatible with newer version.
      # We cannot use `-DWithSharedLibluv=OFF` as it will bundle `luajit` too.
      # TODO: Restore brew `luv` once support is available
      system "cmake", "-S", "deps/luv", "-B", "build_luv",
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
      # https://github.com/luvit/luvi/blob/#{luvi_version}/Makefile#L73-L74
      luvi_args = %W[
        -DWithOpenSSL=ON
        -DWithSharedOpenSSL=ON
        -DWithPCRE2=ON
        -DWithLPEG=ON
        -DWithSharedPCRE2=ON
        -DWithSharedLibluv=ON
        -DLUV_INCLUDE_DIR=#{libexec}/include/luv
        -DLUV_LIBRARY=#{libexec}/lib/#{shared_library("libluv")}
        -DLUAJIT_INCLUDE_DIR=#{luajit.opt_include}/luajit-2.1
        -DLUAJIT_LIBRARIES=#{luajit.opt_lib/shared_library("libluajit")}
      ]

      system "cmake", "-S", ".", "-B", "build", *luvi_args, *std_cmake_args
      system "cmake", "--build", "build"
      bin.install "build/luvi"
    end

    # See "Sharing Luvi Across Apps": https://luvit.io/blog/alpine-luvi.html
    (buildpath/"luvi").write "#!#{bin}/luvi --\n"

    resource("lit").stage do
      system bin/"luvi", ".", "--", "make", ".", bin/"lit", buildpath/"luvi"
    end

    system bin/"lit", "make", ".", bin/"luvit", buildpath/"luvi"
  end

  test do
    assert_equal "Hello World\n", shell_output("#{bin}/luvit -e 'print(\"Hello World\")'")
  end
end