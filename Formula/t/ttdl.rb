class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.20.0.tar.gz"
  sha256 "7eb5e02f12418eab783012a3a51fd3ba7847dc15b64604a6617674330e26d19b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "521ee9208511df0c6e8dd787f9aca4e18c20e03973b30937e4efd49b746a95d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6182ce12bb6b50ef73af47d6a4680401676fb5a59088eb584fc066b0421fe4bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f93be78e845c3a28e4ce324dd5e0e35635a724428c90015c5f32e6d3d6f782"
    sha256 cellar: :any_skip_relocation, sonoma:        "06515f1eec2e991d207065f8db5e6bf02a495486bae12d158e9f44d8798cc077"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74067cdc98836f9f353c02fa18fa096d39eab40665d3e38b50506f646a3535a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c2acb317d5cfc34b755b9a9f9c4a8b8834648791bf8e581759281218590c547"
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