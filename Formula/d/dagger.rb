class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.11.5",
      revision: "4bb033022abf1b3bc2e54567b637a5d5cd910854"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12ce20b12e4598574aa480a65c4292ab2c50e931752a0747ecdfd2d5b2707096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "753fdd26516e9509fcc575e65260eb9a81057ee8bebeb9c5469133ec83307404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c955a51ade2745bd8db7b11c363ec51f8613ae49042c0f702f43cb5c4d77b19"
    sha256 cellar: :any_skip_relocation, sonoma:         "727d245196a8560e813f2d2a0ccccdb0edac31c8e49d086c7af6a1b212ca2114"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a9a337435722d05357e4d6ddd0a8e44fd79c0e1d76d788f04c1df90fb65fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "2c6a9ba5a58d3f17b281c0b4b46a3b4031d733494e965c53637cf795b2d03229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bcdf7ddadc303629c6e68185032f6c420b38a1ce424ee0fb2c31ce300fbb589"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
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