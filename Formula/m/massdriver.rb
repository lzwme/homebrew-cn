class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.12.1.tar.gz"
  sha256 "35ded36f60aff9b4303a7e77a0f8536c1d24b6daf96ed766bc124747dff5ee1e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33507aa59be69e53919b3204e3d04523d2ab952e1ec469beaecabc93f0b1cd84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33507aa59be69e53919b3204e3d04523d2ab952e1ec469beaecabc93f0b1cd84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33507aa59be69e53919b3204e3d04523d2ab952e1ec469beaecabc93f0b1cd84"
    sha256 cellar: :any_skip_relocation, sonoma:        "1946b03186b876a08a26ff818854bba9a192a2ad0d496c4d409e0384cab4c146"
    sha256 cellar: :any_skip_relocation, ventura:       "1946b03186b876a08a26ff818854bba9a192a2ad0d496c4d409e0384cab4c146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d165499ddf48aa491d6c30e2cb4b5d3dde7df7e3995939a69386f4a327001a70"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end