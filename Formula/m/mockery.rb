class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://vektra.github.io/mockery/"
  url "https://ghfast.top/https://github.com/vektra/mockery/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "b53e611f5e360c3cc44253838597b65ed8df3fb4e5fd13efe12c924f7a53e2f8"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "v3"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fa29432f7943e603658dbe5d745d78d761ee862cb079c83248dca1e27ac72a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fa29432f7943e603658dbe5d745d78d761ee862cb079c83248dca1e27ac72a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fa29432f7943e603658dbe5d745d78d761ee862cb079c83248dca1e27ac72a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a411de8d5392703862ffa30a215c87bc9288d2891995314f15cad4e63df87941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93cda6830c0a6447ff6235de3b30258b46a4c7c5f48f77d0407bb0fde818ca67"
    sha256 cellar: :any,                 x86_64_linux:  "7e0c0a71c466febe2bd27e3efc586649d7d5cfa4a57da3e0ed6304a664bfba9f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".mockery.yaml").write <<~YAML
      packages:
        github.com/vektra/mockery/v2/pkg:
          interfaces:
            TypesPackage:
    YAML
    output = shell_output("#{bin}/mockery 2>&1", 1)
    assert_match "Starting mockery", output
    assert_match "version=v#{version}", output
  end
end