class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "6d1394ff03b8d8690aaa8aac7afb1e23c138b093031c77a97d8fab935ad8776e"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d08f4c7c06f862c038ae85c02068ae349328d11502291770c2f374634136e15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "032bf581a17844e4bafb69c2f34647752940780238516b17fe71176debeb9a3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a53fbc642baf51e3939bb94fae1592843b7cad769f68f8a73597ed1b30363ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "23fc241bc318d6330287bfd27820ed0b4f1dd099311b916698cbd34aa964f6cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69278ec08ebc0f32a7bad3322ef265c1ef2ce0b071a37937f66b20eb0b0f7bdc"
    sha256 cellar: :any,                 x86_64_linux:  "cc50d29f9c9cdd2dbf78b83e8330623c3b4209ef57e0ba220da826b47786a64c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end