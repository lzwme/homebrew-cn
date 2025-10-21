class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "1552e46809a94bd5c351315dca4d69ce4000bb5ee5ea63dfa589fd9832aec2bb"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "068d19014936e9b4b22a6b6b39d32aefb6225feae8e2c2d63f86f88fc290d9e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "068d19014936e9b4b22a6b6b39d32aefb6225feae8e2c2d63f86f88fc290d9e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "068d19014936e9b4b22a6b6b39d32aefb6225feae8e2c2d63f86f88fc290d9e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "540ec3d270ba6a77fd87106495f0f24285fdcf600affe1e458e06dfbe71656f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43b2ba2df54ab3c76f6b0ff2768e98875d83a281eb5674d00c342ccf4dbf07e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6e38c6c8f43c256114a853c0e0afcbd595c62bb8421b55d63018421ad13b88"
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