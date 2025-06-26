class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.18.11.tar.gz"
  sha256 "3433234726aab1cf49d40077328ddb84214bd5da3403e5c7afa02f0c9e0f96a4"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a3533b30d39ed2ea6ccec425966852b78a00206e2400656d5c02cd02742d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a3533b30d39ed2ea6ccec425966852b78a00206e2400656d5c02cd02742d90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43a3533b30d39ed2ea6ccec425966852b78a00206e2400656d5c02cd02742d90"
    sha256 cellar: :any_skip_relocation, sonoma:        "756907a46de1226598a041a9ff0b9a3dd45b766d192c87d519bea14a6a475b39"
    sha256 cellar: :any_skip_relocation, ventura:       "756907a46de1226598a041a9ff0b9a3dd45b766d192c87d519bea14a6a475b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ee8a717043d2e5b2e9671b99bce8d7b4e7f69ab1671cb6c6aa0f07cb0d0b3ed"
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