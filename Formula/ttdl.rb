class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghproxy.com/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.6.5.tar.gz"
  sha256 "9026bce12e70eee497bfe0e69ec101e27b61c0e6583cbb40968a187713141f36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ac77411544e5666ba0a0c7b3d86aacd9d73bd8696097d7d365e4a0d1b61a0bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed3b88905523258f8d8a0f2dc36caee49323cc348e187fc8eb894d7a61a2005"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4abc50b2041e7a8caa550b12cd2efd15decee732d3d480ef0e542e1427ae68ec"
    sha256 cellar: :any_skip_relocation, ventura:        "f609df98499c9d6e9f12109b8280cd4f10c52bcd84ca5d5da4eacb34fea5fb35"
    sha256 cellar: :any_skip_relocation, monterey:       "ea3817ea5298007470b7ec159883f8ba559e685fe12d15be961a6b2427aeba8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f424c264b5523fc6ff3d115e1667701624ba142781cbe592a8e6ada7734b4d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "336e0ef52db73614b2cfdddf1f390f7e313826e398099319cb5c083e4a2e4def"
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