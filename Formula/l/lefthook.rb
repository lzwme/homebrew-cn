class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "3d49f786ecb5b21a78d864528570f224a0ceaaacc27ee1289bdf7d73f0ed2dbd"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db508d30aecdcdbd06cd97854f73cc6d96882a8cd8596f931172fb5cf7ba9ccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db508d30aecdcdbd06cd97854f73cc6d96882a8cd8596f931172fb5cf7ba9ccc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db508d30aecdcdbd06cd97854f73cc6d96882a8cd8596f931172fb5cf7ba9ccc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b931116e566382b11aabb7fffa7bcb72a4889065b35ab4a149671d2aa2577c61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3297183848f29d80aac0ef25baa5b756d78440700391dd082a13650d7fefb59e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1dc134c5a80a86606a9a961e914d95c899a86d36437ca03fb6dff425db0e1ab"
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