class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.17.2.tar.gz"
  sha256 "fc9d0f00fa808176450c8e5d84f8b2503f5252397fb6880fa6fd1dceb2ce191f"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eaf14d37b5cc5a1beb337876123d3f81bbcedc8194c9533b49261b3c80e925d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eaf14d37b5cc5a1beb337876123d3f81bbcedc8194c9533b49261b3c80e925d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eaf14d37b5cc5a1beb337876123d3f81bbcedc8194c9533b49261b3c80e925d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e55a013de6f1c555850682f07820c544c51474fa3c06fb1caf22ced73d0e5ff3"
    sha256 cellar: :any_skip_relocation, ventura:       "e55a013de6f1c555850682f07820c544c51474fa3c06fb1caf22ced73d0e5ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5154caa4ac328c22a3b1e4a3c9a8171273aa3c2fa4db8be11fa2c4230b8f8c8"
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