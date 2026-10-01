class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.15.tar.gz"
  sha256 "8e2ea54882f1578eaac728004bfc8a68e5fdac839314e1ab7533d4b8ce7f944a"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f40b8c1b0708a28f6c13918d50bd76219802ad93c5b8de1e0f209580967ca093"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f40b8c1b0708a28f6c13918d50bd76219802ad93c5b8de1e0f209580967ca093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f40b8c1b0708a28f6c13918d50bd76219802ad93c5b8de1e0f209580967ca093"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3720c7fe7f98f435afff67cea7bbf3927a3bdd59ee235c5d3dbc578ce02aeb3c"
    sha256 cellar: :any,                 x86_64_linux:      "22a9702a61309a47f92881c38d8022867969fc0ca00bdb5dee1de5f8be67c76a"
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