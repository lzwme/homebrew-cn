class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.8.tar.gz"
  sha256 "1a96af44d352302cc2c184f9a69249525f15a8fd313b170de1d686603d729811"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db476f63773950b987f4cdd5430d79f28fcb3b520c7f9494b2bf53ccc2ef29e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db476f63773950b987f4cdd5430d79f28fcb3b520c7f9494b2bf53ccc2ef29e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db476f63773950b987f4cdd5430d79f28fcb3b520c7f9494b2bf53ccc2ef29e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c985e74c1b77434c08969e3a4279244e47dd496172da3f7123bcde1da410fb2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e10f343a965e02c7dea6aaece4f75f3646d37811ffdfb4d7e10fc53e3e4ddbfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a22073030af6906b35207c90dff9cf9a2d0dcb7d6527fd5275a0298ab1fe2bb"
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