class Lpeg < Formula
  desc "Parsing Expression Grammars For Lua"
  homepage "https://www.inf.puc-rio.br/~roberto/lpeg/"
  url "https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.1.0.tar.gz"
  mirror "https://github.com/neovim/deps/raw/master/opt/lpeg-1.1.0.tar.gz"
  sha256 "4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a"
  license "MIT"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?lpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eac4a8e81fe8fe1855702941aa034eb8ea81f681b8db009d9e36a2aaf7bcbf1e"
    sha256 cellar: :any,                 arm64_sequoia: "8941c78e5300722a52c3a62e6471122a0e4efa4508ec8117ae137616ed8a7abe"
    sha256 cellar: :any,                 arm64_sonoma:  "5c1eae57e7209af8cd6188b560cd9a9850bb8424418439c48cfd091b70845942"
    sha256 cellar: :any,                 sonoma:        "d31eb5abcd32e4730e9b26afc41221db254e0042187940a0676d5ba01253c7fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd2e06b940f418826f890869f7cd6d5512365bffd99d50fa78f0c3f13c061c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d940ee7049f656e7920ec081adb0b3a7237a65801addfebacfe71d5c2bf2f08c"
  end

  depends_on "lua@5.4" => [:build, :test]
  depends_on "luajit" => [:build, :test]

  def make_install_lpeg_so(luadir, dllflags, abi_version)
    system "make", "LUADIR=#{luadir}", "DLLFLAGS=#{dllflags.join(" ")}", "lpeg.so"
    (share/"lua"/abi_version).install_symlink pkgshare/"re.lua"
    (lib/"lua"/abi_version).install "lpeg.so"
    system "make", "clean"
  end

  def lua
    Formula["lua@5.4"]
  end

  def install
    dllflags = %w[-shared -fPIC]
    dllflags << "-Wl,-undefined,dynamic_lookup" if OS.mac?

    luajit = Formula["luajit"]

    make_install_lpeg_so(luajit.opt_include/"luajit-2.1", dllflags, "5.1")
    make_install_lpeg_so(lua.opt_include/"lua", dllflags, lua.version.major_minor)

    doc.install "lpeg.html", "re.html"
    pkgshare.install "test.lua", "re.lua"
    # Needed by neovim.
    lib.install_symlink lib/"lua/5.1/lpeg.so" => shared_library("liblpeg")
  end

  test do
    system lua.bin/"lua", pkgshare/"test.lua"
    system "luajit", pkgshare/"test.lua"
  end
end