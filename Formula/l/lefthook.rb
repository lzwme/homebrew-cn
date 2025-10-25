class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "d23c05f0ce9825888fa088c5a27610e8d08043fc0c0682de170585f29644afbb"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d95e4ece016ad6855aace24efda2daee2b6d5803efaa2bc0db11b9211c922fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d95e4ece016ad6855aace24efda2daee2b6d5803efaa2bc0db11b9211c922fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d95e4ece016ad6855aace24efda2daee2b6d5803efaa2bc0db11b9211c922fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "34566eb85c49019aa2d954db6ed9a71ba0bdd6b1957a880dcfd77332d3b6835a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3f17aa3950e9e5df4689a357eb09aa7145aea0d5e0fc1ef8203204a997d2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbec78328d6ad375671e799aae36611bce95f0da2a5fd86f6115c833891bd8dc"
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