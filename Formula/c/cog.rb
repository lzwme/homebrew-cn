class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "111f427630b8de711a78045e4d79a569e579ae1dcb5efa6c7f9024198d62dccc"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c4a8639eddac358d3a929510a961ce45ad7723f93e45fb0144cc47fc9661726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c4a8639eddac358d3a929510a961ce45ad7723f93e45fb0144cc47fc9661726"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c4a8639eddac358d3a929510a961ce45ad7723f93e45fb0144cc47fc9661726"
    sha256 cellar: :any_skip_relocation, sonoma:        "416ecb8006dc386b958db77829e5a2f2a5c9649c45f7f85110fb58ecb729a43f"
    sha256 cellar: :any_skip_relocation, ventura:       "416ecb8006dc386b958db77829e5a2f2a5c9649c45f7f85110fb58ecb729a43f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "117a9a41f784c16cf3db32bc963dec0093825413bb16b0348f2a202d3a67850d"
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