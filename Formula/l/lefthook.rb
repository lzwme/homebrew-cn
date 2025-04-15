class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.11.10.tar.gz"
  sha256 "26264eb80f0ed0a43396823c02f3db8311cb7eb5ccecdb646a74d3232c1ea665"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a51f4e62c333c3a4a786e2303d195a0a2d0e0ac8ce1e997de37c77ee5a117da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a51f4e62c333c3a4a786e2303d195a0a2d0e0ac8ce1e997de37c77ee5a117da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a51f4e62c333c3a4a786e2303d195a0a2d0e0ac8ce1e997de37c77ee5a117da"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1671f22e7dbd69b5b469b2deb18dd651cee22efd809c41c309dc40573ee6289"
    sha256 cellar: :any_skip_relocation, ventura:       "d1671f22e7dbd69b5b469b2deb18dd651cee22efd809c41c309dc40573ee6289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5018b1b615379e8cb498078c93fd5a47aeef0d6221ca2c4db48b2985b9b29d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_path_exists testpath"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end