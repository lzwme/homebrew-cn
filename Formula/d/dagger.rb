class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.12.7",
      revision: "9823a005d5c1c131345c3278bd6ef197c65d1c8b"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a66d3e06fa8d7bdfafe6a1e89427add708f66f1f982735c482edd08a9d77fa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a66d3e06fa8d7bdfafe6a1e89427add708f66f1f982735c482edd08a9d77fa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a66d3e06fa8d7bdfafe6a1e89427add708f66f1f982735c482edd08a9d77fa3"
    sha256 cellar: :any_skip_relocation, sonoma:         "89d31f6577ae140fdbff88b226a8ab81f2b1042f1437d0d9e25a8854c81ce8ae"
    sha256 cellar: :any_skip_relocation, ventura:        "89d31f6577ae140fdbff88b226a8ab81f2b1042f1437d0d9e25a8854c81ce8ae"
    sha256 cellar: :any_skip_relocation, monterey:       "89d31f6577ae140fdbff88b226a8ab81f2b1042f1437d0d9e25a8854c81ce8ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70ee2019d28173f58be29867055fef51e19a727d1ebfb85678a69eec4fa43815"
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