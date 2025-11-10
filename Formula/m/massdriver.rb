class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.1.tar.gz"
  sha256 "2c41f7f5edce44c1b1784732dce7d37d1db5382d6f2efbcfe33cc88c246969c0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c74149c490a909784e2743637a06f8842f7c82db358695ea1a80921464059b2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74149c490a909784e2743637a06f8842f7c82db358695ea1a80921464059b2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c74149c490a909784e2743637a06f8842f7c82db358695ea1a80921464059b2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1097f13171112d27a493a25f7a869cf69088b56d1bbd3e4f784a5ed10430d18d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3093968c647cf4162fe993fa1c7b8dfd7df79c1856ae2f929b75ece1974f3877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58830d28c65a98df04f02a7e37143c54a28edace81d46a8474edad12776c7d16"
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