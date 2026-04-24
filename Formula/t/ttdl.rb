class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "66fe98f0a43b83bea3ac18420ba2d6b1a40a1f7a87847484e3c71e493d63acd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a576bba5c49e9d25de218f27e461c9a6b9a2a5af19ddb680f6b10f98533d73de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "072f7f8ca3f751a0443dbd9dfb567c8159d0c5fb1d4f56dd55df8f1f7e55e395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a930294705983aeb3b40e9ed98cfcc0c7afd816bd28d6bd9f4b697edcbcf87e"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a6a0db00a18d6caca27b513a1bb6e5a87245d29060e01c5323f0b9d21efe3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db95670e3ae69b5fc99588320051ad37e7f75e7dd56fdcfd6f3da0f2941ace84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb35f35f93955459a1f9a3875dfce3141ab901a59afbb2198c19829a6b54c638"
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