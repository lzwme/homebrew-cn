class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.12.6",
      revision: "c3ab515efcb3409035fa01486ede16c059abad61"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec075e98d0e9c27ed3c3a3e293d865328490d7e2c89af9eac9e5b1ee96160a73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec075e98d0e9c27ed3c3a3e293d865328490d7e2c89af9eac9e5b1ee96160a73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec075e98d0e9c27ed3c3a3e293d865328490d7e2c89af9eac9e5b1ee96160a73"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2a7c0d015a35ff893dcf5d4195732431358b69f9a1ae5f79728cf1fd2018fcb"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a7c0d015a35ff893dcf5d4195732431358b69f9a1ae5f79728cf1fd2018fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "f2a7c0d015a35ff893dcf5d4195732431358b69f9a1ae5f79728cf1fd2018fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74b0f7e3a8a9c019a8c05a49a20dd738275e31fcb6ccbe1f90309d70ef69ddfe"
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