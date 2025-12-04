class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://ghfast.top/https://github.com/YosysHQ/yosys/releases/download/v0.60/yosys.tar.gz"
  sha256 "24ac4d75cdc05c4d486a874ce5e834b773e4906b2723016921b37d1a3e7a1bf9"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "60515410e29e955ce6c92f45b30645d4e4fa5e5a928902323c3b4fb4f9a8fb9c"
    sha256 arm64_sequoia: "cc06de53b5b5a74f445fd241eb9dd5ad5f7ecb4d1014ec258b7a71a773c0e47f"
    sha256 arm64_sonoma:  "608781236c6c9019611f7588444da6d0c7d6a6a7508217421dd544e5d46379bd"
    sha256 sonoma:        "c14757d0bdc4ac821f02d0d6f518247e75399e68cd2221705e1edab207102387"
    sha256 arm64_linux:   "e6cbbafb9d19590092d1bf00f2d55632e9a67e4d6e7abef0be21a86df132a716"
    sha256 x86_64_linux:  "b16cb9431a2fcd241f75e963d35684af46319148bc29c988eed9e0c69855927e"
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