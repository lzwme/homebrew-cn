class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.12.3",
      revision: "c544987c852dbacc285d46c5688cf4ff6d5360fd"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4de8a557fe0bf44695e8b778732e32e41cf56b404f0e805da9b5ab2b1f5ac022"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a016a56f9d9557bd4cc864c7f86cc4d5d4f3fd286a1497e525992bf0dfe28b3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ec6e62a4243ac2c7fbbd6f9cccd5923eacfe251b4f9a52da2f501ce845a9c84"
    sha256 cellar: :any_skip_relocation, sonoma:         "037d63ffb8042bd3eafa0f8b13d41392734d0d84d175b09213dcdc5381dcfdc4"
    sha256 cellar: :any_skip_relocation, ventura:        "b788c0f1adc5871192d2fc9baa5db7e823d50f7fde74a8d7cca8e151a7c5d1b5"
    sha256 cellar: :any_skip_relocation, monterey:       "cc563117625e31b2361070b2d650e858399e1971cf1936a8919267599f6e4c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45df262b0c439cd2afefebceb10cba1ab46fbdc24b6b53a9a6920a293ff2dac3"
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