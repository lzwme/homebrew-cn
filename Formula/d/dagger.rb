class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.12.3",
      revision: "c544987c852dbacc285d46c5688cf4ff6d5360fd"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d39849750406ea51e2b81788ec20c29d31ddfa53e481ab6bef08f456dddcd476"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7ce74b8f856df88df8ecf59c657b43cb7f9eb1e7d5ae744613f136e1e3cc403"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5cc989986752b75c8511cb3d60bb2ab1b72292b35f1f71641fbdd09344069ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "02e8ab09556a548f653ad46ec7583dc9e43e2d35f641b50d27b5c111abf3a5b9"
    sha256 cellar: :any_skip_relocation, ventura:        "41d13b2f2de5e083e7a7788c92db2aec47a95cd2850a1c729ca5aeaf900bec9e"
    sha256 cellar: :any_skip_relocation, monterey:       "b5b64738c8d4626584211f0b015f2c14c53ff060e8b637e2e30071b04d715afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eef9250fa8a591b153d2bf8c48dfef72d3406f6d8daa57ec68d5d0f2242f5383"
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