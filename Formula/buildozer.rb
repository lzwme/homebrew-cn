class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://ghproxy.com/https://github.com/bazelbuild/buildtools/archive/refs/tags/6.1.1.tar.gz"
  sha256 "76f96aa30635b0566bee078aeff822ec6220f3801c69b9f16f689cd7da901ec8"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48dcfa258c0ab7c95678353ddff26ed34d5d4ddbef306f758a95ba195807dc3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48dcfa258c0ab7c95678353ddff26ed34d5d4ddbef306f758a95ba195807dc3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48dcfa258c0ab7c95678353ddff26ed34d5d4ddbef306f758a95ba195807dc3b"
    sha256 cellar: :any_skip_relocation, ventura:        "9fd4677ed3b7c74887af80772fb4a87c2b2f92f67bc8269d68e48720d7731a25"
    sha256 cellar: :any_skip_relocation, monterey:       "9fd4677ed3b7c74887af80772fb4a87c2b2f92f67bc8269d68e48720d7731a25"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fd4677ed3b7c74887af80772fb4a87c2b2f92f67bc8269d68e48720d7731a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44a095437a39ba35fecf375d748dde66af07d086c07ee9681441c398baf17680"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system "#{bin}/buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end