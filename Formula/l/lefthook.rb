class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.10.5.tar.gz"
  sha256 "6b0955afc84a0080f36f6e71c6e19f91cc791a9150a8edacf481d26671cf36d6"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a529443aea61d7d066cc62a2fe93903144f2041a8e24103552abd47fda83b932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a529443aea61d7d066cc62a2fe93903144f2041a8e24103552abd47fda83b932"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a529443aea61d7d066cc62a2fe93903144f2041a8e24103552abd47fda83b932"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b5d46a61a918b81af3117ea0eb9e4aaedaf3c54c321d420dc6e41098911eab9"
    sha256 cellar: :any_skip_relocation, ventura:       "3b5d46a61a918b81af3117ea0eb9e4aaedaf3c54c321d420dc6e41098911eab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68625587fa6ded999aa8bbc8ed189c81037bbfb2abee9d4bd5aec37a5469f6ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end