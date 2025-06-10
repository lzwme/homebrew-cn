class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.15.5.tar.gz"
  sha256 "9925d4d6c797ef92ff1633d3eb15f51e746d994421c78a8ea7f7138cbfb6b6c0"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4eb672cdf5305a5c01670138c6586fc3b1ea4a134549377d7fef14e09bffd6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4eb672cdf5305a5c01670138c6586fc3b1ea4a134549377d7fef14e09bffd6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4eb672cdf5305a5c01670138c6586fc3b1ea4a134549377d7fef14e09bffd6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e78adfb7346490ec16ad15024a5fbeb20ccd2b768b72b8c6daf4bce8fb4bc0a1"
    sha256 cellar: :any_skip_relocation, ventura:       "e78adfb7346490ec16ad15024a5fbeb20ccd2b768b72b8c6daf4bce8fb4bc0a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c38bbc3aa1751765916412162bb143dd82d57600decd4f5c66bb5c6d1919123"
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
    (buildpath"pkgdockerfileembed").install buildpath.glob("cog-*.whl").first

    ldflags = %W[
      -s -w
      -X github.comreplicatecogpkgglobal.Version=#{version}
      -X github.comreplicatecogpkgglobal.Commit=#{tap.user}
      -X github.comreplicatecogpkgglobal.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcog"

    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    system bin"cog", "init"
    assert_match "Configuration for Cog", (testpath"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
  end
end