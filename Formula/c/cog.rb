class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "f16beafce7d6f617132e4d366400e80ec5e6a8f0b6e6828098184b1343d455b1"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43332a20425357da6847afbc604ead3e881f7d68058d21bc0d9743afad51edc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43332a20425357da6847afbc604ead3e881f7d68058d21bc0d9743afad51edc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43332a20425357da6847afbc604ead3e881f7d68058d21bc0d9743afad51edc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "326b58c179aec49a8a2e885a68b63304b6c362384a63e3261777dc86c8bb56aa"
    sha256 cellar: :any_skip_relocation, ventura:       "326b58c179aec49a8a2e885a68b63304b6c362384a63e3261777dc86c8bb56aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54e337b502c0cd700dbe28401b64b50d418bcac644df812f80e3e490066284ee"
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