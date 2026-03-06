class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.24.4.tar.gz"
  sha256 "40ad51b8e5f2ca63f22cdabaeaaca662fc9ed68dbc5d85b0aa84807ca8a2d20a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "495bbd7616c2f8a22ce4b38785da0500197d2ae04d2c827fc09089fd00298a4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a54051e5436cfed4f798fd943ca6ddbf7a263f59236d999220d92caf1937409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4dba77c30cf502d2c62aad88137ec3c6453ec37fb963b6b7f0ef399a609d01c"
    sha256 cellar: :any_skip_relocation, sonoma:        "36cb6fd3092789884521e82755894b84eabb69e802433850e95647555c221c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1df4418151fbd6d3ed1c3c423eb953baa87f5e4ec228c43cfc1b7ccb2d6709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b55c0af61127e3d715859a8596a7b34dfa8e94b0b2ea11177ceda0d42617032"
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