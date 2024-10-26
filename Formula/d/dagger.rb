class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.13.6",
      revision: "00ec4e9ccc41d6e79e5b41f28d278ad74b41f9a7"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05247ddd3f905fcf20d7a11ba064a5d5e3eb0e10a001a8fc7782dd25cfcfe914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05247ddd3f905fcf20d7a11ba064a5d5e3eb0e10a001a8fc7782dd25cfcfe914"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05247ddd3f905fcf20d7a11ba064a5d5e3eb0e10a001a8fc7782dd25cfcfe914"
    sha256 cellar: :any_skip_relocation, sonoma:        "19f05b5be8ebed3503a66a27a2823029a61b3690fb730e435be885f1ed111e27"
    sha256 cellar: :any_skip_relocation, ventura:       "19f05b5be8ebed3503a66a27a2823029a61b3690fb730e435be885f1ed111e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4635e8444bc709617f3bbc6bb72a3a13b481d29c02835e26c1f7bd60b8ec6fdd"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
      -X github.comdaggerdaggerengine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end