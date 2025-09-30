class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "4f610a4ab9622d7073f3f11e315ec62e6c24aca3778904937b7c8e6beb893f7b"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7a1ec25034bd7d5ad6f1f5f16aa43b9c0bd32c5089c8cd835b5cd75fb9a22be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7a1ec25034bd7d5ad6f1f5f16aa43b9c0bd32c5089c8cd835b5cd75fb9a22be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7a1ec25034bd7d5ad6f1f5f16aa43b9c0bd32c5089c8cd835b5cd75fb9a22be"
    sha256 cellar: :any_skip_relocation, sonoma:        "94b3cf28aafde1d8f434e27de2bcfc02533131d85158e49128881ba5f412bf73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2711bf503af4ca4fdb47434b0f2452847f88ab4b1dbea87707d58b8cc42ea417"
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