class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https:github.comNixOSpatchelf"
  url "https:github.comNixOSpatchelfreleasesdownload0.18.0patchelf-0.18.0.tar.bz2"
  sha256 "1952b2a782ba576279c211ee942e341748fdb44997f704dd53def46cd055470b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25689776796afacaf452e8e74dd3805bf9ff129c00f3cc886c0857db9802c9db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37888c994e481e2b6a3a212c689195e2ca6dbeb681779845bbeda5a52262c1b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd75a287bcecfb33a2ca07c92225435571804a8e73f30ecc4769a6a7443dc2d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef4527c4a98121dd6fabcef87f00b3a8dbbd6b9cbd24d49d972a057f49ee4080"
    sha256 cellar: :any_skip_relocation, sonoma:         "730a1f960f0965576c25edf1525ac57c14177ff4ee5fa74d731f6892c0f519ef"
    sha256 cellar: :any_skip_relocation, ventura:        "6b230c2ad0a046653bb8f2b5652d069f4f9e7c6f17bdb4d4e9b6dc35a94a3693"
    sha256 cellar: :any_skip_relocation, monterey:       "37bd9ca1e04a76f8b160fdaf1f1f76c2f396a264f5d3af88670d3338c577638b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c12fe3723bc1b72e6635713ff2f6c12cf7f13e8e9533fb58360a2c163187d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8a76cdde4a5666cccbcdfc328bfb77f5d05b63a52ce103b487166be696ac6b"
  end

  head do
    url "https:github.comNixOSpatchelf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  fails_with gcc: "5" # Needs std::optional

  resource "homebrew-helloworld" do
    url "http:timelessname.comelfbinhelloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  def install
    if OS.linux?
      # Fix ld.so path and rpath
      # see https:github.comHomebrewlinuxbrew-corepull20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}libld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system ".bootstrap.sh" if build.head?
    system ".configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("homebrew-helloworld").stage do
      assert_equal "libld-linux.so.2\n", shell_output("#{bin}patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}patchelf --set-rpath usrlocallib chello")
      assert_equal "usrlocallib\n", shell_output("#{bin}patchelf --print-rpath chello")
    end
  end
end