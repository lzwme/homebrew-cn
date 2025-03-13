class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.16.3.tar.gz"
  sha256 "0793036ee5deba69566625283a95df362d518274a9ebec1ac10e461e64b24b90"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5618ba07f5874473fefca47e99d4e1c181af7479e1197ef3c90339ecb0a0e7f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5618ba07f5874473fefca47e99d4e1c181af7479e1197ef3c90339ecb0a0e7f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5618ba07f5874473fefca47e99d4e1c181af7479e1197ef3c90339ecb0a0e7f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eec02be9e0ce3b70a80472ab3b97792f6a22cea49242af78ebc9ffee140e33bc"
    sha256 cellar: :any_skip_relocation, ventura:       "eec02be9e0ce3b70a80472ab3b97792f6a22cea49242af78ebc9ffee140e33bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fae2bf3b6d25d00783fc7c761398b3f353af19274254d4220a3178ec11dbcc"
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