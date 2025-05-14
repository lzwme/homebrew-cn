class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.18.7.tar.gz"
  sha256 "385beabbec0c7cee357418417447f4f65cec124f961ec4f85c16c29c5fe55ccd"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb9b11abbdefe398730fe21aff95dd804db971f6a8da09a71d341c9511b90527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb9b11abbdefe398730fe21aff95dd804db971f6a8da09a71d341c9511b90527"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb9b11abbdefe398730fe21aff95dd804db971f6a8da09a71d341c9511b90527"
    sha256 cellar: :any_skip_relocation, sonoma:        "23a9f1b0f9696ca5401ebaa196b7058ad05c21261270428fe58298e4225c56ec"
    sha256 cellar: :any_skip_relocation, ventura:       "23a9f1b0f9696ca5401ebaa196b7058ad05c21261270428fe58298e4225c56ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75078eca567e1d99e0332735f5e625c593b90f8b2955942619f5c019822d3f80"
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