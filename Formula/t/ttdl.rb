class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.15.1.tar.gz"
  sha256 "0788c5178ab9613ce20095e94868157f49ec051a558a223f318ca05279d1a63d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "201a5816750d5b758fc3f6245d859720f82572cdceabe9481a8d3c39d446675c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9756d6931611cea0d49ef90074d66d8808e7e0d411bd7aeacd4671ccb01a0c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11da123826f564572d3597dfbb820e0cfb90ddb3feebb79df6c568a03b4ed77f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1abbbb0c293bea750da496f96c605e7a592b1460f9391e93b5c89c195587ba2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "325a8cdb7a1f3e4e4097712f5ff0df6d5d336e3dca2ecfed6e813ce95555064a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80b9e871efa5f4ad9ea0061cb6e4f7054092e9b659d324fde0499d0c925bb794"
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