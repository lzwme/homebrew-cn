class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://ghfast.top/https://github.com/luvit/luvit/archive/refs/tags/2.18.1.tar.gz"
  sha256 "b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c"
  license "Apache-2.0"
  revision 17
  head "https://github.com/luvit/luvit.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "76da44eb50749c14d5f53f399b7e5d62fad29bb3e7b43773cf4f50b3fd64f95f"
    sha256 cellar: :any, arm64_sequoia: "5b1b78d5a59ab60b60fc2e3002984c4f093355650618b1071d15795badaf8bf8"
    sha256 cellar: :any, arm64_sonoma:  "c13d2e50a7b904639402bebaf57d3950beede924919e7528737e3e7914443658"
    sha256 cellar: :any, sonoma:        "dba055214499a24f0e2eed860c700237f348fe4b075c8696a7f572cc0145cf5c"
    sha256 cellar: :any, arm64_linux:   "c93ff4028455ddcde29e859517a126391e23b3d42fb516693eb2c77a25975325"
    sha256 cellar: :any, x86_64_linux:  "b78289458f546ff7c5fe145820cd72195e3b9714245df695f4b3f223fc2cdde6"
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