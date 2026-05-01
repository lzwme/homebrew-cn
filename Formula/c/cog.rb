class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "3ef48bbd86393594ed516a50843b4c74b269c8a756bb10c80d65b933e23efc92"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c6b840cccee56a2dd23a84358266dc31c8bfbf484913586fa762f3509406bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e945436c1a48f9be713b5687762e8a47d89ad1ef21d388b900a45685bde1d924"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5c6100cd7091539e3bfa1a3d531e2bac2400ec8cd34dd455331e42e83609870"
    sha256 cellar: :any_skip_relocation, sonoma:        "850c6f3d544f106409be20817645a06dd363436a06fbe05f15c9cd3090883798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfc4c860725b0850cd97925ea7b2dcb227cb4bf4615a00794330570292592ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "420ccfd75eb4085157c853d88fed7602b96816be17c259ef3527da6f23a8cc26"
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