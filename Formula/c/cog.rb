class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "7573c8fc1afcc9cf774adf10623d7253de85c2fbc3ad7697c82c79a53dcd9e00"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb15996c5a7b271eb3971058c8439f0686cb2506e6478ffdebdd68382e2c87c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb15996c5a7b271eb3971058c8439f0686cb2506e6478ffdebdd68382e2c87c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb15996c5a7b271eb3971058c8439f0686cb2506e6478ffdebdd68382e2c87c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a509d0696a3d9931a4b65a949d2620b68a8464e7654f67078722f251fe62941f"
    sha256 cellar: :any_skip_relocation, ventura:       "a509d0696a3d9931a4b65a949d2620b68a8464e7654f67078722f251fe62941f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ed9652d7b7a05d71d8374da9c7d4cdf2b255ac2629836df64997d69bde1c7e0"
  end

  depends_on "go" => :build
  depends_on "python@3.13" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.13"
  end

  def install
    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end