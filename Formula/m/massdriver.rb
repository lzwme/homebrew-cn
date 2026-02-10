class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.7.tar.gz"
  sha256 "567b8c0501511cc20d52cb0341c2c360db6de3d3ec26d8001a8e67a9a4513aae"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0061a7ff872b44f5d84a6196f0d40e80e93ec071ee788ccbf43acdcc50e7dee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0061a7ff872b44f5d84a6196f0d40e80e93ec071ee788ccbf43acdcc50e7dee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0061a7ff872b44f5d84a6196f0d40e80e93ec071ee788ccbf43acdcc50e7dee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ab18b4b5b8a930c4af194f78e9c7580a624461019e3b4b64270d734eea56e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87a0467ce190521cb3c842ab0b5010cd5e85166f1653991b9458e0c19cb526b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46cd2e774ce65edc918d28ec9a730cf22a4557b27f1e1c5ad7b6462d17194ee6"
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