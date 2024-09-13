class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.13.0",
      revision: "e92f5a44e359341c0ef0eab09bf7391678295033"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7c912f6cd3ea2d8afeeff9905322a60791d3b63225d916c865d110f661f5282b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c912f6cd3ea2d8afeeff9905322a60791d3b63225d916c865d110f661f5282b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c912f6cd3ea2d8afeeff9905322a60791d3b63225d916c865d110f661f5282b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c912f6cd3ea2d8afeeff9905322a60791d3b63225d916c865d110f661f5282b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cad9a88d7c80ebfda3862e5f327d8b69256e2252aee533c6cde1d51365e37a8"
    sha256 cellar: :any_skip_relocation, ventura:        "9cad9a88d7c80ebfda3862e5f327d8b69256e2252aee533c6cde1d51365e37a8"
    sha256 cellar: :any_skip_relocation, monterey:       "9cad9a88d7c80ebfda3862e5f327d8b69256e2252aee533c6cde1d51365e37a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "146f8e717e2eab53a0c2dc71182737147dad1fe1af02a1407ecca6c022d27f2b"
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