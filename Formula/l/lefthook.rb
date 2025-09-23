class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "694d0f5ada0d1e3a3b453e3588984c4e77037684c5d18716ff50b7e1f4eb4570"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc7cfa447ee94f2a63ead068494faed175cb9d7274cf38fdfbbe1abf9074583"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cc7cfa447ee94f2a63ead068494faed175cb9d7274cf38fdfbbe1abf9074583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc7cfa447ee94f2a63ead068494faed175cb9d7274cf38fdfbbe1abf9074583"
    sha256 cellar: :any_skip_relocation, sonoma:        "942832c7419e0b9dd0a8f0efa7c8fc6dfb6fc9cc231033edc6867703764ea5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "480c7ae6df34bd21c273ac910f9c866858bebfa75a74c7eaf694d0d7a0d2742b"
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