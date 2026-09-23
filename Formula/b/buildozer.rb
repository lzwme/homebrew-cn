class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://ghfast.top/https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "fa0b905032d49a621679e7318875736e451895a1417d992fbbebd27f82b83c38"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e88dbd94907b34f837078b805d52bec9c40a37b187b85682bdf2b5d652dd80ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e88dbd94907b34f837078b805d52bec9c40a37b187b85682bdf2b5d652dd80ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e88dbd94907b34f837078b805d52bec9c40a37b187b85682bdf2b5d652dd80ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "473e471cf4689022c15f8c41316fdac552a25b3788220e8acc193d9eaeb3faec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c14a0fdb799eb08488f1e42922a9ab82d62828e63acac2026aa92c33716b8a95"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system bin/"buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end