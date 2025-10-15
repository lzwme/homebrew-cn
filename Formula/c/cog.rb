class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.16.8.tar.gz"
  sha256 "a032ffa750f96c1947034249e2bba898c16dc6b474a074dac72ca1124bdf7a9d"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0d7ce713afad995b4ce295fc28d5b9753777f5f6c4beee10cadf8c315e5d0d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0d7ce713afad995b4ce295fc28d5b9753777f5f6c4beee10cadf8c315e5d0d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0d7ce713afad995b4ce295fc28d5b9753777f5f6c4beee10cadf8c315e5d0d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2126cde70b8e56011c8857b31833b011f72ac77c76bfe79bff379127b835d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d21db0e8c506a414a5939f36c796074fe92eaa971ec46b68f6651f10aa026e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ae6769d10f569e271aab438fd913a1ba0bbec0935dca42cfc0d7bd155dac67c"
  end

  depends_on "go" => :build
  depends_on "python@3.14" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.14"
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