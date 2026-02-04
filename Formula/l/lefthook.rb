class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "feb00b91236947383377742a9f6517c91459c73ba38ffc0496c45017e9ff8377"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "499f69edcb7367e720c96e5caab6e88874905062a5bb54ac6c016cc2aeec9bdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499f69edcb7367e720c96e5caab6e88874905062a5bb54ac6c016cc2aeec9bdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "499f69edcb7367e720c96e5caab6e88874905062a5bb54ac6c016cc2aeec9bdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "07e88686656e83010ad8edd0a7ff6bea1d01ae0d595de6cbd4bb310b9ff4a10c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71d078a1369c8f2f80f615ec0bc7a7b70d79e58aa84bb1897ccfacb0378b8e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c22865aff470110a3057efa8f49c9901c3c2f3699157a932a57a3b32cd24e8"
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