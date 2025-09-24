class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "a36685e1e4245107173b1a5e8abcd00cc65a475be330254a4647a3a953aeb4ce"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "357d8b7c026221b07998f67c9ca6d34954a925957b377a9f43e8a6cb5f7da7fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357d8b7c026221b07998f67c9ca6d34954a925957b377a9f43e8a6cb5f7da7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "357d8b7c026221b07998f67c9ca6d34954a925957b377a9f43e8a6cb5f7da7fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "64043f374c89d3ac3c457a4b4a5e326698adc463599bb6ee366f381c421c8a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390a3835f38ec2b4b5452e4ba126209b74701c7bcfb04df28e760ecd7c9a59ec"
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