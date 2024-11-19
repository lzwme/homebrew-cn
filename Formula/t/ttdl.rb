class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https:github.comVladimirMarkelovttdl"
  url "https:github.comVladimirMarkelovttdlarchiverefstagsv4.5.0.tar.gz"
  sha256 "33284fba39f21c3bdd15a7463b8990521ab8faf3af7c2f4f1a28dd7e338f24f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d79f99e0d5651e0193b62989a5b7d6b970c561c2aa61e1965d1627a576c7f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06e2d55f2fabe8b4bc2ef490d683fbbebe1f35da4442c6a0f1583901a0a0b6fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41ff03c7ea0dc00121c03fe5dac029e99b538601f4644b2625d80906546dbdc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5010752b2763a80dd8538e1954532cc86cd93fd86c26c14b29d437b985a4aaee"
    sha256 cellar: :any_skip_relocation, ventura:       "670de03bcebb74ed7709496b7d592d09b7938e9421e10c9aeabdbdb07fbb00ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96aaede9b361e70e42949c1e2304910d0435fa94288b356fb11d12a84938fc1d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}ttdl 'add readme due:tomorrow'")
    assert_predicate testpath"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}ttdl list")
  end
end