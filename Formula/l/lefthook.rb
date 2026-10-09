class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "9c2595cb9c81b8390341dfb5140f5566c9bdb9fc893ac47df2e65b984ab16ad2"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43d109cad9475a904786d9a25156590dc187b552f19720fd5c9ed9c8a21c8715"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43d109cad9475a904786d9a25156590dc187b552f19720fd5c9ed9c8a21c8715"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43d109cad9475a904786d9a25156590dc187b552f19720fd5c9ed9c8a21c8715"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e2bc3f1a93b1d99b2d5e54dd32bc07638ea72fea2eadbbfacb0e69559fdba38"
    sha256 cellar: :any,                 x86_64_linux:      "4b9a25dedcddcda8e541f056928b9aedd521d29929db0db8a88ba579c4a86cb5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end