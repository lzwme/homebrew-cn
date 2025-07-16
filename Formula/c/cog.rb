class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.15.11.tar.gz"
  sha256 "262948c152af1eb2b08b2cae7b928c484dc4420f3d139bb4ed680bb83b539029"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0355e286edc4d98612c15c539230d1855035ec2bce22dbe87a96cc856a8a2a03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0355e286edc4d98612c15c539230d1855035ec2bce22dbe87a96cc856a8a2a03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0355e286edc4d98612c15c539230d1855035ec2bce22dbe87a96cc856a8a2a03"
    sha256 cellar: :any_skip_relocation, sonoma:        "f14a191b61b5ca5e65a82e8d90aa2feabf0fe0abf0a03d0a9ec36c14e6371845"
    sha256 cellar: :any_skip_relocation, ventura:       "f14a191b61b5ca5e65a82e8d90aa2feabf0fe0abf0a03d0a9ec36c14e6371845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0bf1452baa73caf2e1bf206fde121dc0507ac966d451be1fe90a048c2fd5797"
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