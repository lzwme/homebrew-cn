class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.16.6.tar.gz"
  sha256 "d8fa48f9221eef25964b9d2db6f07c4327e61d61a555192344d52f290d421df7"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "062873e5a65312a667ce8a610813974941587000b005052de0fa61f9d69df6a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "062873e5a65312a667ce8a610813974941587000b005052de0fa61f9d69df6a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "062873e5a65312a667ce8a610813974941587000b005052de0fa61f9d69df6a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a582a64c3f360d6d7e9d46448a633872cb1425e29c31d8abfdde509d76e9bc"
    sha256 cellar: :any_skip_relocation, ventura:       "10a582a64c3f360d6d7e9d46448a633872cb1425e29c31d8abfdde509d76e9bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61cbd9f95ab345ca086553d357aa33e5e2d3a72018aae92d434d008a2d81f2fc"
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