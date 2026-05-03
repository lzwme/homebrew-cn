class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "015134c38b34708d0b93e41332dd7f198401ed5f07e97360f3c513ee87e7630a"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fca6136f09aedbe0e6d8e69be24a7ea3c8faa862281bc383f3c58342f6560e13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5a2e034fc7f6f08f4f08e91dcb2ebc12c637333d3395a8a02223203422faea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8cc761f355dcdb7992c9a311df406e34e9c29994c5a73a65a847a9e9c828ad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2c12d76ad232aa4826402cf44a9d20033b6006d9335e87b6aa1b8e5003b6d68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4f6c89cd3d2cae4a5fae6883227881576ac88e0a77cfe44637fa9da7c4e3afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e0eee359fab81d9b905b8d1efd38d433fdd0999beb25a3ca10e62a33b68dae1"
  end

  depends_on "go" => :build
  depends_on "python@3.14" => :build

  conflicts_with "cocogitto", "cogapp", because: "both install `cog` binaries"

  def python3
    "python3.14"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end