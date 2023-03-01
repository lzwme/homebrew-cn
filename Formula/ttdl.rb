class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghproxy.com/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "2a6e3f9e70a823ba773321f8c94bd17c12a78378ef7f3b23ff6ab61e5a673fc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48eece8cf6d090143fe3968d9a92ed90b04753f30d3463c7a07188819a633d93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fc2180529d4149a8b894205f6298adf2c30a3436a5f81f802555d57c2b6f675"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0905363ac902b86b7c16809eed664a594e65c7c835817a7e701e464e2b8a652f"
    sha256 cellar: :any_skip_relocation, ventura:        "4fadcce4c2a92da1810a55d09a838bda5957a3d0271e8619fd32cafb9fe7a116"
    sha256 cellar: :any_skip_relocation, monterey:       "7bb0f0975fcad7c8a7f6b4244f06503ff25b3a1139161384eaf325131b6a6c40"
    sha256 cellar: :any_skip_relocation, big_sur:        "97d42d50ff4cb0f074f18e357bc690431395cb459b7406860a87f74470111cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98414cebf13806335a1d021c0a1b3e11198d0e21476c6642e613f563754ffcd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end