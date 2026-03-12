class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "ddf710e81562e938b6e6d2d3cc8e6127411d553511f554a73afe9d932709bc43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5eb8a7de834a12359d38c1497635e4f91da1e439ffa7b9b5d08e27af7f5696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c971f3766af9208e15f0b0fbdae75692783b663b917a07fd44fbcb770868331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26193f059d58158b39e158fc8ed0c9432df6f1e92ebeec81d290feacf93b745c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a7b614ddcfef08ba914d2d5e0d99762d26def85b28635811fcf095ac8d3ffdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "181ce62176ac174abc814e47790d333560a18a071e870bb0c6d54c91592d40a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73ca33482fa1f3a9f8244fb5d9c74643d7d6f298c27b01532cf6156058b3d755"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w  -X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bento --version")

    (testpath/"config.yaml").write <<~YAML
      input:
        stdin: {}#{" "}

      pipeline:
        processors:
          - mapping: root = content().uppercase()

      output:
        stdout: {}
    YAML

    output = shell_output("echo foobar | bento -c #{testpath}/config.yaml")
    assert_match "FOOBAR", output
  end
end