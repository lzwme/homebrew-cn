class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https:github.comemilprivergeni"
  url "https:github.comemilprivergeniarchiverefstagsv1.0.10.tar.gz"
  sha256 "e85e8afeac78bdb5c5800caf3fd955dc8b9342c58e39cedd2d64fe3be2395d7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b775e7a385e466eda130afa295776be8e348646efce95266157ebc8248ef1dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8811a2240a55d23e358132da0c2fb3cfc8cac2efa70493445e46015ed7c46627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a886b43b08ace024b9552205e24b7c107b6f49c1ab7cf07c847e451000c7a20"
    sha256 cellar: :any_skip_relocation, sonoma:         "179cb8bb88b9b7a54ac062df130cb255969ca6bc8c9a1807ea2dc265f21b1af3"
    sha256 cellar: :any_skip_relocation, ventura:        "25c95c94855186fc6502b40efc784c125691a61f96b377da01e781ae01487eea"
    sha256 cellar: :any_skip_relocation, monterey:       "1a33a9df4fc5b057009ad65603f7055a827a3d694d67c93153900353494ac07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc2ea347bd71c6215c392a50820b017bbcfe2a5319758c405de38594c46b048"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3:test.sqlite"
    system bin"geni", "create"
    assert_predicate testpath"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}geni --version")
  end
end