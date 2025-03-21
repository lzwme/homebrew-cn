class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.17.0.tar.gz"
  sha256 "c5c9032192250b85f06390e67ffcc56d06926b16d52ca325e6e235b317fea5fe"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebbd85efeb1e3f872801f8465e50920be02f825abd2e9337b4cb43e5900d0490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebbd85efeb1e3f872801f8465e50920be02f825abd2e9337b4cb43e5900d0490"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebbd85efeb1e3f872801f8465e50920be02f825abd2e9337b4cb43e5900d0490"
    sha256 cellar: :any_skip_relocation, sonoma:        "11cd097a6b73a4386bf64d06b63b7c112263999506e2aee1deae6d5baa8161ac"
    sha256 cellar: :any_skip_relocation, ventura:       "11cd097a6b73a4386bf64d06b63b7c112263999506e2aee1deae6d5baa8161ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b75931dede3ebeb899c23f8304bdb5f522454675f5292d55282ba8664553c282"
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