class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.24.1.tar.gz"
  sha256 "f396b384ba3cc77882ec27e88af55e15da9685838485627fcbbda7b106160294"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa3c1cfff30a48e27cbb79a3aea1d637f8a56f22349f4ffa8d69611486dbb2ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "625bfe4204c555fd1b2fcd010214e2ceb447526fd5f4de67ca2a5d1c99655f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2988a8def865b81da419dc3d4f7b53bce49d969e9d201da669ff6921aafd71a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a67a7af1e8e53e09386f99be51a31df61783ea5c67c8d7f72b6e28f9c0b9b6c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d78016b1ba5c9eb5cb8d3020d6b605d8258a09e639f1c10160aab02abd851c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d14ecd93740c1b9f6cf37a496445ba2d189db0f4552097105de9f1f23734224e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end