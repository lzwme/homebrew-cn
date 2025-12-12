class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.19.0.tar.gz"
  sha256 "fe18852dc64f94464ca871988199c6347412ca0f9d13c64d003aae39fd6f56cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74867cf78c41e9fd9f802638403e4e1852a24003040921479cf5e03af799a898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41445e5e8b4025eabc586ee6acedf4cd027c07d7358c64d89bd19a09ff559598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e016c342a503a16a74956b038bfb96f28f10ca9413ff6dfa298b5fbc2ce3dfa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "52c236820c817758cd742b0a22699a43c23ce01556b1d6746db7d011b961fa88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1ac998aa0b2f04be31eafc8e787c18f39d4f53c3fa1bf463f97c76527b3b1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6de5618d1bed2ac2acfeaa4ac36261a17d1b026c1fafeda4dcb096a1cf47ed"
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