class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "5319c036b1108911d6c776bd1d8a519bb73da1713345c6e4665f479fb714d4ce"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19aa9a1296c4bb483f387615ccd8e8ef80dcb41e8ee645a7146d2d6e405654dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a75062cf29fccab9855fa10cdcc0e441c43042de63b0d509d151456e4feeeec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0823c0540fd817ad4c6eaff1e07dbdd24819d37dbdd0a3b745145476b7373cb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd8317ae0505d31d546e04ea5d428acf7e707502cfde13f70f112f6ffb35ddee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "636b510168b0a56cbde9eb8658d5bb78d8e1d93dbc076f7a387baeae517680bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3398c34c5b50243e35f4119b1e11f78ea682942ae9e1b0ddbd13972f429e6dd7"
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