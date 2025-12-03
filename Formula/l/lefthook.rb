class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "4ae060253ce4f045caf4188abbd540c8baf186aa6f836647a397e1903da85e01"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "497efdb116fb822e30e594fe81dff37695567cdc58281be58eed464509b472c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497efdb116fb822e30e594fe81dff37695567cdc58281be58eed464509b472c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "497efdb116fb822e30e594fe81dff37695567cdc58281be58eed464509b472c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6612e892ac1d279479c1a74999c767bead7d8cd9f1bae11a25df53a253d71298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb83a5bb1174d77184e6a156b7f871bb0f40377e5e099eaad7d36bbe4385d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a306075e57ae6a4028b0335395ac3a4f0ab782e4eb1d744020f59654558549e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end