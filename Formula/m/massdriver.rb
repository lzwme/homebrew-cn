class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.9.tar.gz"
  sha256 "052673412c109cf3010f8299868acdc0529e16282179fb657de6ff3e1b6ad741"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86374ad7a7abac985a5fc985a26864ccb7ca8ac9df57c27b34ef44f8d660c0a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86374ad7a7abac985a5fc985a26864ccb7ca8ac9df57c27b34ef44f8d660c0a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86374ad7a7abac985a5fc985a26864ccb7ca8ac9df57c27b34ef44f8d660c0a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "01c0c32d809c5d9a5df1af4c1e2d99706160e4754a78619210a6ec9fa9fe173f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af1534340368ec341af3b0a7f65bf0eed24613e9e9c8d116f4e0ed4a257a64ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d27f6d0c6c58756270d753a05be55b4d4bf49514adaf874d05af32d08853037"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end