class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "45fea629ff599670b69712dfc99b8ba7a82599762e73747efd8b27a4ae76db4f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80bc26c1ecfc716e5ce11de6f213fda3704f072a331d34d1590d76751304fa1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80bc26c1ecfc716e5ce11de6f213fda3704f072a331d34d1590d76751304fa1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80bc26c1ecfc716e5ce11de6f213fda3704f072a331d34d1590d76751304fa1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d2d24ad0f6823f621769a63f0644d33d25072378a8ed36c36a0b2ddf1057b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "375af820d34a211af8cb54d4ddcd58910751289559bf5ac58ddbacccee19b8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb3cb07bc6c6d29cc02c72110c2e0d6cfde652dbb7aeac36d2f68d1241c034c"
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