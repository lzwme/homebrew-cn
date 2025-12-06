class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "a0049233d49714da86cb26e1696f55975736568d8112979904e78a5ee75a2549"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d3eaf7ce8872a9541811c5ca7d5dc5fb183fe3fd42ecc029c6c4969f6d6dd59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3eaf7ce8872a9541811c5ca7d5dc5fb183fe3fd42ecc029c6c4969f6d6dd59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d3eaf7ce8872a9541811c5ca7d5dc5fb183fe3fd42ecc029c6c4969f6d6dd59"
    sha256 cellar: :any_skip_relocation, sonoma:        "c69df7a9fe4b758d92f467c2725a000d017951ff277541a77aa866b217f56393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc3e4e38d1f6aaf923a9693356471ae479213169b2a4bddd5c0d434e1cbd0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c297996e091e21313c281bb9f14239c0529cc4b45a376b4b814d0801d5ec3019"
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