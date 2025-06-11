class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.18.10.tar.gz"
  sha256 "1dfad5897e59f52d9e084cc523667cbcad2e93f8e02b1b91b8663407a7cd559f"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66c7895f1bcf0eaad31d7f36e7b31b6db5763c2fcbf9c6940e0f2769e1807e3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66c7895f1bcf0eaad31d7f36e7b31b6db5763c2fcbf9c6940e0f2769e1807e3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66c7895f1bcf0eaad31d7f36e7b31b6db5763c2fcbf9c6940e0f2769e1807e3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3419dc1c4d285d23b7332b15126fbef14e4177f2702f5fedefd63255e5030e4"
    sha256 cellar: :any_skip_relocation, ventura:       "f3419dc1c4d285d23b7332b15126fbef14e4177f2702f5fedefd63255e5030e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3018b69dc4bf84c1b92b96d926a4f56c0dcbf26bcd6d2b2dfce5d3f0dc8a4063"
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