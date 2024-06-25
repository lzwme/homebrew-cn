class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https:xmake.io"
  url "https:github.comxmake-ioxmakereleasesdownloadv2.9.3xmake-v2.9.3.tar.gz"
  sha256 "82a9bb6961a39bea8f280c1413d54854423f8f92e2ff43ee1c0fead7a3b5edd8"
  license "Apache-2.0"
  head "https:github.comxmake-ioxmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "499b583a08ab7e4056480964d0bc4a24ba742794544a6f4ad61eeed7ab7451b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "383cd125aeafc1eaff9ee0b93080285aa45ce8f75b19d3f19b095b8d00afda47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c69ac34872e8750a677e30540c87c74bafc81ed3044455312b042377b306fb63"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dc8f8900ef16dfe2dedcdc66012738b2a376ee9781c39364d7ef2d9a9dc6d11"
    sha256 cellar: :any_skip_relocation, ventura:        "d2751c686d5725eab1203c9cd42516271a4c857bc5c177871532a305444cdd1a"
    sha256 cellar: :any_skip_relocation, monterey:       "5bfca3d8bb77f5a057d66f29e91dfbea47608f26124d11561cad7f22251f391a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10da87dbb6a68eb7dab6a813404dbba8a86c0f6edb961f4d05d299091e68b4f9"
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