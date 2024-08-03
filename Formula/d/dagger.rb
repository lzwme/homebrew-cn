class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.12.4",
      revision: "c0d2d86f30df377f3245b828b84112b3e849c355"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48f66495ba9dfdff8297b146c9d978cad1d143a10096aa11c305f27493d8aab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a0df27fc36ece7019dc9edcc273cc5ec12948c46de7542954d453a685a853b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f2197a23babc772ed4bdc484813202869c1688d31650230d4956d969515f6c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f6491ec0a01f44c86848eccae4b43eff85148b279fd6ae25554af2ad3e3c8a1"
    sha256 cellar: :any_skip_relocation, ventura:        "7527e796947c7495c678fd8f86cb60014743a1d63c58048ee8529de9b10259cd"
    sha256 cellar: :any_skip_relocation, monterey:       "c05ad82ff4c9f3b1d1c115844891d83d96daeb8bffa5a08b20e6b1b4e692a546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "425e0ec43d0f18636a85d1d3d199185e346f3404750ac714ea9db72fb4e20e75"
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