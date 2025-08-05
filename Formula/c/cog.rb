class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "cbdaa5c10c4264f14e0278049e16e61183a93d3021a38cb31c77ac514acd6db9"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70fc23a56a8a761086b0214e8d08cb384506cf36b30b37e4448e3b9b16e1782c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70fc23a56a8a761086b0214e8d08cb384506cf36b30b37e4448e3b9b16e1782c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70fc23a56a8a761086b0214e8d08cb384506cf36b30b37e4448e3b9b16e1782c"
    sha256 cellar: :any_skip_relocation, sonoma:        "50c12f5b8dc5245bb60eacb946d2020322c55730f0b73ccf6cf9dc9a106f8d3a"
    sha256 cellar: :any_skip_relocation, ventura:       "50c12f5b8dc5245bb60eacb946d2020322c55730f0b73ccf6cf9dc9a106f8d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03327c5e9fd59133aff40e7607c2639c3098366bf4bb6d18268c66a2a9e463e5"
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