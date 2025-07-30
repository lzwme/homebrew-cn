class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "63707ee74087b7a996f0393fd6f4c783b498c763824d510422de1309193d4dc2"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "297bb10590cff352a0c8672d843b4e3d76f03e48c51e59f7917d738c81a11991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "297bb10590cff352a0c8672d843b4e3d76f03e48c51e59f7917d738c81a11991"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "297bb10590cff352a0c8672d843b4e3d76f03e48c51e59f7917d738c81a11991"
    sha256 cellar: :any_skip_relocation, sonoma:        "d947346aa4fddc503d85f57d19327efb6a457b3058ff716e5fc1936e3f0b39d3"
    sha256 cellar: :any_skip_relocation, ventura:       "d947346aa4fddc503d85f57d19327efb6a457b3058ff716e5fc1936e3f0b39d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d5e14e134c164cbddf56e5ba5caa584520356cf7c2b41b23f391d59a344357"
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