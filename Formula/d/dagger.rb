class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.15.1",
      revision: "196f232a4d6b2d1d3db5f5e040cf20b6a76a76c5"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "898eeae54a1806142cef71c2d395850e824af010b774c543fe3bd31b3f853177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "898eeae54a1806142cef71c2d395850e824af010b774c543fe3bd31b3f853177"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "898eeae54a1806142cef71c2d395850e824af010b774c543fe3bd31b3f853177"
    sha256 cellar: :any_skip_relocation, sonoma:        "8132e76b933945147a8ee85e47ae7f516521cb83c09b329af6a22ce6e2fe7fcd"
    sha256 cellar: :any_skip_relocation, ventura:       "8132e76b933945147a8ee85e47ae7f516521cb83c09b329af6a22ce6e2fe7fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c54cf930b16c59f46301f131e42a87cb7013df53b00733f5c24a9d839e6ac595"
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