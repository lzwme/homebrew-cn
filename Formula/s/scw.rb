class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.51.0.tar.gz"
  sha256 "7467045861f7d31c2278af1002e263336f3c5e8d36ab4362d1a5b8dd74cdcf4d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "118d98581463f2af982c05f123642397299a15d9ad66c2010be30b4fec280e5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12de0f27b363e5ff44ec4c663e1d8eaa422cd69e70a15bad2d42279cf428d585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e94a1b51dea69ba4ade83cc1161cf968c670d6a8e5efdc30a2d8effd9ba78540"
    sha256 cellar: :any_skip_relocation, sonoma:        "39db6ad4b04269f943d8cc1912fdc969d287aad9647aec2c6a9d3c31dc455a76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4f274b67a2cc1f129d7e26138abca433579b7743adafc07a47139716391b95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3c8e0a601aae6389a473883ce1c4e96f803dd4a6505d0e63fec4170372bdfe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end