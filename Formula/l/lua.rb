class Lua < Formula
  desc "Powerful, lightweight programming language"
  homepage "https:www.lua.org"
  url "https:www.lua.orgftplua-5.4.8.tar.gz"
  sha256 "4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae"
  license "MIT"

  livecheck do
    url "https:www.lua.orgftp"
    regex(href=.*?lua[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9279ae3479091e3228c233f390e696ba3e7bbcaba8e9e15311cdc862fe7bbd12"
    sha256 cellar: :any,                 arm64_sonoma:  "e93d3935a8bc573858690650ac13f1aced0098a523bb7071dc359d556afd9100"
    sha256 cellar: :any,                 arm64_ventura: "0b3992a9aabd0ccb38e6edcac9188a67343992058e3b72921f81c2eb0c3ffc49"
    sha256 cellar: :any,                 sonoma:        "c8816a8327ee6a27121fa5a955fcfbac1788474f0d72a8c75876170dc455b497"
    sha256 cellar: :any,                 ventura:       "e8e982877166d4a0b87e50a3aeae7613b98f0b596da2a292353f1df1a2e1be8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ca1da210601500a01485460ff6c6a7ebc2c4c396ac0d376b25295308ccf1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4edfa03fd344d303def0992a7e02fe5e614c3e9c256e44b84348bb0fe108a13"
  end

  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "readline"
  end

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https:github.comHomebrewlegacy-homebrewpull5043
  patch do
    on_macos do
      url "https:raw.githubusercontent.comHomebrewformula-patches11c8360432f471f74a9b2d76e012e3b36f30b871lualua-dylib.patch"
      sha256 "a39e2ae1066f680e5c8bf1749fe09b0e33a0215c31972b133a73d43b00bf29dc"
    end

    # Add shared library for linux. Equivalent to the mac patch above.
    # Inspired from https:www.linuxfromscratch.orgblfsviewcvsgenerallua.html
    on_linux do
      url "https:raw.githubusercontent.comHomebrewformula-patches0dcd11880c7d63eb395105a5cdddc1ca05b40f4alualua-so.patch"
      sha256 "522dc63a0c1d87bf127c992dfdf73a9267890fd01a5a17e2bcf06f7eb2782942"
    end
  end

  def install
    if OS.linux?
      # Fix: usrbinld: lapi.o: relocation R_X86_64_32 against `luaO_nilobject_' can not be used
      # when making a shared object; recompile with -fPIC
      # See https:www.linuxfromscratch.orgblfsviewcvsgenerallua.html
      ENV.append_to_cflags "-fPIC"
    end

    # Substitute formula prefix in `srcMakefile` for install name (dylib ID).
    # Use our CCCFLAGS to compile.
    inreplace "srcMakefile" do |s|
      s.gsub! "@OPT_LIB@", opt_lib if OS.mac?
      s.remove_make_var! "CC"
      s.change_make_var! "MYCFLAGS", ENV.cflags || ""
      s.change_make_var! "MYLDFLAGS", ENV.ldflags || ""
    end

    # Fix path in the config header
    inreplace "srcluaconf.h", "usrlocal", HOMEBREW_PREFIX

    os = if OS.mac?
      "macosx"
    else
      "linux-readline"
    end

    system "make", os, "INSTALL_TOP=#{prefix}"
    system "make", "install", "INSTALL_TOP=#{prefix}"

    # We ship our own pkg-config file as Lua no longer provide them upstream.
    libs = %w[-llua -lm]
    libs << "-ldl" if OS.linux?
    (lib"pkgconfiglua.pc").write <<~EOS
      V= #{version.major_minor}
      R= #{version}
      prefix=#{HOMEBREW_PREFIX}
      INSTALL_BIN= ${prefix}bin
      INSTALL_INC= ${prefix}includelua
      INSTALL_LIB= ${prefix}lib
      INSTALL_MAN= ${prefix}sharemanman1
      INSTALL_LMOD= ${prefix}sharelua${V}
      INSTALL_CMOD= ${prefix}liblua${V}
      exec_prefix=${prefix}
      libdir=${exec_prefix}lib
      includedir=${prefix}includelua

      Name: Lua
      Description: An Extensible Extension Language
      Version: #{version}
      Requires:
      Libs: -L${libdir} #{libs.join(" ")}
      Cflags: -I${includedir}
    EOS

    # Fix some software potentially hunting for different pc names.
    bin.install_symlink "lua" => "lua#{version.major_minor}"
    bin.install_symlink "lua" => "lua-#{version.major_minor}"
    bin.install_symlink "luac" => "luac#{version.major_minor}"
    bin.install_symlink "luac" => "luac-#{version.major_minor}"
    (include"lua#{version.major_minor}").install_symlink Dir[include"lua*"]
    lib.install_symlink shared_library("liblua", version.major_minor.to_s) => shared_library("liblua#{version.major_minor}")
    (lib"pkgconfig").install_symlink "lua.pc" => "lua#{version.major_minor}.pc"
    (lib"pkgconfig").install_symlink "lua.pc" => "lua-#{version.major_minor}.pc"

    lib.install Dir[shared_library("srcliblua", "*")] if OS.linux?
  end

  def caveats
    <<~EOS
      You may also want luarocks:
        brew install luarocks
    EOS
  end

  test do
    assert_match "Homebrew is awesome!", shell_output("#{bin}lua -e \"print ('Homebrew is awesome!')\"")
  end
end