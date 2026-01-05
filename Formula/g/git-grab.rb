class GitGrab < Formula
  desc "Clone a git repository into a standard location organised by domain and path"
  homepage "https://github.com/wezm/git-grab"
  url "https://ghfast.top/https://github.com/wezm/git-grab/archive/refs/tags/4.0.0.tar.gz"
  sha256 "b73f67da252ce02a17e7ee09c9e971374357281f6d92c14117312db4e7b4a66c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ad0bf8aa5fe11a4586f93ba584edc7d1a892963b4a0dbd351ce5d839c8418ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf3b41afa6405f5ea4559cd5b9425899c46035c9041b051f1b31ab161fe2d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8126099e34d16417a38d643a7d274954eb04f68fc6d771e3b78ea24b5835172"
    sha256 cellar: :any_skip_relocation, sonoma:        "a52c98397a4dc8a4c79912b7e10c5e57ae309780d1caa95efcf02768d42e21a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d41abc68980f05d865849eba05c8f47fc1c61a6b9b58669057724984d3d1a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3844a2995efcf4a872d27aa63d42b2a83ab8d3cc3b37a8143686dd7866581e3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "grab", "--home", testpath, "https://github.com/wezm/git-grab.git"
    assert_path_exists testpath/"github.com/wezm/git-grab/Cargo.toml"

    assert_match "git-grab version #{version}", shell_output("#{bin}/git-grab --version")
  end
end