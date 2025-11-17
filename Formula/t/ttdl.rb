class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.15.0.tar.gz"
  sha256 "f65b43e9e1f5980b78a8bd84446b6f8ed9380098af273e4a25aef7c926da428c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edd673394915c892ce4567f70feb4c335651c032b77facc0800f91ac0125acc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b969c3fd5d6493b39e0d0f21817d8f28f1c4a831e015c4fb19833bf25080cee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2496467a38db220518df28a9d6b237193ec4b766a1b7a2815dc6a9841ddf3d69"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a80d41627c3668e18d2de3318dcb96ce16fa415db9569ad4bdd8e5345e863c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc868f4f2983d89ce533cabceb381a28223e31c30fb9641554d1ae75756a928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b09f2510a6909ed3945bf2f059de1fdf625c45ef0fcdbd68ec75eaa4f5e08a7f"
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