class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.25.0.tar.gz"
  sha256 "9378fce43a33a08f97f4b02c724e46b44435b02eca1902bcf7000cf93ee0cb1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "012eb20935a3ef87c04991917eef55f5d6b5a76cc1a47ce8dafe2fb5817d36ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7464f4602e649a140e2c5a89b2a04c89e87d66e289120710145807916c45d197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f668f3616e44e17a118a4421e88920412be90c6028e0f53e4a51ed4f7ae61ee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a89fc3fb03ad1f87ed556c9d56c79d74b4d1616cae3a81779ccb5dda7436348a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "132db806023a9d41f1b1608c7aee193f0987cf13cf331f18e5eeefa27df33759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32be8f90cd42eb3dec9793566cb511069e2e9ee513c1850dd9319f01d7d19af9"
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