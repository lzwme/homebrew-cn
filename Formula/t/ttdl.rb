class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "0a26eb79bc8270b7c2535ed1db1c3af3506bff929c2520b90a3a3cb4d7d2745a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8d84a0e166c45b061415ab10d28cd34ba600af22473c5a436b21640024e86c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1acaaf62b8091359bf109fb558e7f817e24e5563727cb85cb132304d85f94d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82092532ee872f07c359b7922f36d8604cd2e012b73df7993a50dda9c03e60d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8acf63e79f03235f461f50ee8390c2b8d63dd757f96073da2fe3d05661c92a72"
    sha256 cellar: :any,                 arm64_linux:   "7d30a5166ac253bb238869963f806f7d66bffe8d7772abcfe3020d7f5b6b0ad2"
    sha256 cellar: :any,                 x86_64_linux:  "c6571d0edec0126b2a85dfebe1cfcd53b38ba4d81c71d58d101b2908cc58f59a"
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