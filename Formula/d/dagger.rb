class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.15.0",
      revision: "ba70be4ef8c2517bf9b683ca49e565cfaa771cae"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7e3f97c47abe9baac24afa47cf44fbfa7762402d7d405f8f798aa9ee96ebbe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7e3f97c47abe9baac24afa47cf44fbfa7762402d7d405f8f798aa9ee96ebbe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7e3f97c47abe9baac24afa47cf44fbfa7762402d7d405f8f798aa9ee96ebbe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b61937641407f51703a5992620c8685eca7665523586acd5cc36b57fbb435f2f"
    sha256 cellar: :any_skip_relocation, ventura:       "b61937641407f51703a5992620c8685eca7665523586acd5cc36b57fbb435f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238705051ef078e07d08490391ffebc54b086682ffc19fce4b4516bb7d619445"
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