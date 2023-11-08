class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://ghproxy.com/https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.35.tar.gz"
  sha256 "a00643cf4cf83701bfa2b358066eb9d360393d30e8f5a8e65f619ab1fd10474a"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "0fd685fe1938c52ee3e27f43efd5bdc6b0058e8dcf7928908c3a81d162a95b3d"
    sha256 arm64_ventura:  "7f2b4603513539b4387aa5daf4f5024a48c412f9daa3b184606e24b8a20e94f8"
    sha256 arm64_monterey: "d01bfc258b3b199ea789b5cc638a9a8256dbec16abc1626ba6e6be6100694bd9"
    sha256 sonoma:         "1e4ccc674d9e5039d10817280de9f2a2d11f52c669fc3a39ac921f21adda8915"
    sha256 ventura:        "9a4877b91caea6356f2372fd842a529d6b2d257a4e01650401dbc70ca11ac5e8"
    sha256 monterey:       "3bbf84a348054773b2fc47bfd38e6b7e81b8650963276f7e1a013490a26a3ec5"
    sha256 x86_64_linux:   "19bd9d6b8835607554f22041caae774248c88b7c82640321796600fc548410b3"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end