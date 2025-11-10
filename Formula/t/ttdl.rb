class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "42551a9a53d4c88a3be495c30e4075b31f02ddc4d302afdbba3d8dfc3083b690"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35a23b309e5e7ec7736d786cdefa97a631886805af18c37150070d811c1839a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba658000f6d55e011dfc0d48daa394695186ab283b73d0659712b62c39b0d0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13b224d39433068b9ac48e7429f17f6917ebb2c860945bb346aa20512257a676"
    sha256 cellar: :any_skip_relocation, sonoma:        "767c93bea0fe3e484af138c8b04dc61e08f7e4e4e9a0b0dcc5bf3802f7a3d8f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e81dc6dd57379cc37a0dfaaa23ae4e3db25963ef02bc5ac7e1761bbeb914ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7194b49b3e45a451fe29d6592160fd1388facee981ac3d07fad55272aeb70d8"
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