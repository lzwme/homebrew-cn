class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https:yosyshq.netyosys"
  # pull from git tag to get submodules
  url "https:github.comYosysHQyosys.git",
      tag:      "0.47",
      revision: "647d61dd9212365a3cd44db219660b8f90b95cbd"
  license "ISC"
  head "https:github.comYosysHQyosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "169b8cf3e39b28571d779a3a02d820d4866257ba33971ec57e5e67a5f4e2aa74"
    sha256 arm64_sonoma:  "7fe58f97d396b7fad404e52729186177ddcf898476bfcbb5c3345b338d481949"
    sha256 arm64_ventura: "33bf2da782644eccb342b940646f49e2d911e3501ced2d0057929ecf68bdfda5"
    sha256 sonoma:        "0059ff08049c4b62f35b19a86812e15f023b78967f71b7a7023f8167d602cb86"
    sha256 ventura:       "5835a2c9d4cd9231347b1f4010947f22d8a5e02b537eae5a1d8397cf27bc23a5"
    sha256 x86_64_linux:  "26fede326d695af0d7768ada7874639a7c3193ecbd14bc8a932d6be13ab1c93b"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare"adff2dff.v"
  end
end