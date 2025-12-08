class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.18.0.tar.gz"
  sha256 "bf8f4c53d9328d537560a7a21bbe073bfcd4a79bdcc5f8e5112b99bf5ebe36bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25146ca88f48f235528ff32c69de9555443d0a993ed7df4e82398ef03bba038c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1fdcbfeb32fc0752c998e672427a3cdcbd733292df2fc00be135e19ab64df6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b84830328cc3582e306efb6483ab95ce7c42c826f75b36a37ab552f9a0fa7309"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a1a4c8ecd32d3146a9e90f58ed03a562611da73767d0a590eb2cb9077de0a32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aade463913e94988704241c847bffff80693ecdd9a1a1af5aa566d355a0b768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b02ed74588d562509fa7031e437e6c4431dec0c8ba97ee08aabd66bff5acb8f"
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