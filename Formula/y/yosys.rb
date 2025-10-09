class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://ghfast.top/https://github.com/YosysHQ/yosys/releases/download/v0.58/yosys.tar.gz"
  sha256 "c67f35c0d3c6946b7bce6eb168180edfda7f1ce295bf4c3ac1b7cd7ccd81cb4b"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "18392fe1527aa0660d8238711c8a127c0cab6d2e3511450102598aa136969ed1"
    sha256 arm64_sequoia: "6c5caa17e472bc26d46573e99f3e61a550287c5f97ee3baea2b235af841e4d30"
    sha256 arm64_sonoma:  "293b4aceb772bda99a60493b23b5ba9b816d7cad249eb31ee2ef360ef9f6038f"
    sha256 sonoma:        "e4ff1452d36e55ec1c7999b169339191b77ad2dd408829ece31dea6930f707ce"
    sha256 arm64_linux:   "cac7d9c91ad93812cfa3e52cdccdad1f818fc5a7b7820d3c68c3053b363c8a81"
    sha256 x86_64_linux:  "e33ceaed105cdc58f7004938a3f4ee1655d991ebbcbfc6a49ff1040eecc36a9c"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "libffi"
  uses_from_macos "python"
  uses_from_macos "zlib"

  def install
    ENV.append "LINKFLAGS", "-L#{Formula["readline"].opt_lib}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end