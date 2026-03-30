class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "dfd9eb0eb2f58901e0c4c3ad440179157b09186cb4ab4601c7a20af4fd937829"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "969740fa22ea2ca79957bb05b2ed851d9b6099c1cbe6fac9dd0269b2b0cbc718"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64c088314527868a3b52d4612a086d90b531e406561f3193da9b4da680d8484b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d4d76b7e79c86bab3ddee4f3958ab1ce0924ed0ad15ea13d2cdf96a779f7892"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6bba2d8df66fb7265d828f6ab0a15737b0ac6621f219649321eb57b3983d063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cb5d67288699b4442a6711736fc3a20d36c86f5a619ebd892fe4bcf46ffbbff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aee5657e88f1a435cb7542b36fdc5f3c126a9fae1bd8569d04df545b7a0adb2f"
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