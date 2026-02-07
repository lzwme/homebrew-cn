class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.22.0.tar.gz"
  sha256 "edc0d6e1771cbafdc307c386b1ede236e1ab67b2f04002436281fce326e6d518"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "193c816e9b8b25dd79362831bc8486622f016d209e8f0bd5b29e399af80eac8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d0500c9746d45c3c24a9805964e119402013195e5a5f450033b2db5b54cc37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc84ffa7c8e3b15431226574b71fe2a467f2af9a2f47fd27c48a665990a01c76"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d3e3d45fb5529d90494618c39814e4ca0f63d59b08ef0fd33eec3334ce16377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95bb5dbfde1f095391e8b5ee08bc4cd0c3535dbb3a5deb69dc01cdf168a8a2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56a170f5b214dd61ffcb0a540a97631e46dd0cb5506e24f3bdd9664c8f650666"
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