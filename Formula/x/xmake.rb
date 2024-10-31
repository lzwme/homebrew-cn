class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https:xmake.io"
  url "https:github.comxmake-ioxmakereleasesdownloadv2.9.6xmake-v2.9.6.tar.gz"
  sha256 "47f6efcb00f90c98a02c395f973b4d55bdd3a8fe452676dce57b55c055759686"
  license "Apache-2.0"
  head "https:github.comxmake-ioxmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "392027a4b901dedb75adbc4d11b868a96c223cc437a0f1c449bc06322781cc83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "958ea919c8a987c55c754078c8d0434e32036d3d3fd0f13a8df1e75cbdb03a55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d654e3e5e4c52385020c654d778962d4a196e5d654b0a8f0775c419594fbada0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd6f30bfb9f11e1107fa0d8f6bc2193e1931b542c40941c4de347bf2a39657dc"
    sha256 cellar: :any_skip_relocation, ventura:       "81d44a529f9c925f339ae55c47396e428f20aac0c12d2456f0000c55c2b94b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4638a1742739d66cc380a7964a0458694320e497da2b8da9672af01757ad40d"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system ".configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin"xmake", "create", "test"
    cd "test" do
      system bin"xmake"
      assert_equal "hello world!", shell_output("#{bin}xmake run").chomp
    end
  end
end