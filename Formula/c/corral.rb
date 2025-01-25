class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https:github.componylangcorral"
  url "https:github.componylangcorralarchiverefstags0.8.2.tar.gz"
  sha256 "26dad1803e8d06b659e82868957ceeebc85cb359b793da0e1ad8c02e86644b21"
  license "BSD-2-Clause"
  head "https:github.componylangcorral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bf46a9f879d765f5b4934d1225e7e3628d89eeeb861e4249db13d68394ed91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5f379d1abe1f5149675a4146d4e0fd296082ef236f53732a614e006bed00fe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fa374827a91062063dd2671364f343f8a9600ec097b016696947e1f1f223db1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3c9f703f83af5aae58955158e41a06ec7f278c88835788c5284dc83ea128375"
    sha256 cellar: :any_skip_relocation, ventura:       "22d42569b1948244d62de3e221aa049b32b158bb13caa8f89668b832cce137e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cd3c31d9a1fd5c3f13c667eb4ebcfe21ff5a5f60ab51fcf692b0d69ec340823"
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath"testmain.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin"corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output(".test1").chomp
  end
end