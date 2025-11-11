class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "818555b6f51338391f85fed332ae0ad4e457a4b43e2de68105ccf5c36105c665"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73152a4b7ccfe7b85f44b3b2c0cdaafd28244869e9003af34859f94f1946548b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73152a4b7ccfe7b85f44b3b2c0cdaafd28244869e9003af34859f94f1946548b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73152a4b7ccfe7b85f44b3b2c0cdaafd28244869e9003af34859f94f1946548b"
    sha256 cellar: :any_skip_relocation, sonoma:        "06ec4671ed8c1efc26ec169e7e6b330da8ececdb6f7a01b7369c076d8371e48c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9dc53ab455c9ff5f0674a12366d832410dfe49dd969252ca5ad570a10e527c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd606e210771cb2649eb6d983c618dcb8c1199cdb339e2be25e7bcacd3a8e626"
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