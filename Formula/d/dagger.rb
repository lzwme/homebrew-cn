class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.15.4.tar.gz"
  sha256 "d4d2b65232afc77b76450ab8b2ceaa6337cced86bbe538d378eea52ad30707ea"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b97177e8cce2afc6ed5704f5c789da5ff8f1b49950f403a4204a66ad151b77a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b97177e8cce2afc6ed5704f5c789da5ff8f1b49950f403a4204a66ad151b77a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b97177e8cce2afc6ed5704f5c789da5ff8f1b49950f403a4204a66ad151b77a"
    sha256 cellar: :any_skip_relocation, sonoma:        "51c65c172fba6cb8185bfc724c37dd84fff46fae9a0a6166b25bc683a768d823"
    sha256 cellar: :any_skip_relocation, ventura:       "51c65c172fba6cb8185bfc724c37dd84fff46fae9a0a6166b25bc683a768d823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a0fcb164a2d1ba7c2d6602786153c09b0124d95c20ea42a3c735437a0fb436c"
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