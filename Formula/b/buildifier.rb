class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://ghfast.top/https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "fa0b905032d49a621679e7318875736e451895a1417d992fbbebd27f82b83c38"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0383f83fc2ca48bc3ad7c52d3f3d42b55727cb2c3ab43ee7782c2476f8d4825"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0383f83fc2ca48bc3ad7c52d3f3d42b55727cb2c3ab43ee7782c2476f8d4825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0383f83fc2ca48bc3ad7c52d3f3d42b55727cb2c3ab43ee7782c2476f8d4825"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "34dd3e368e125bbf5a51272c6ec089dd1a75cea6c8b72a96f21087fa78be0539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b6b7201f11129e565fea5acbf4e670f2dca260405f6f6751d8b3eb6014e86a37"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end