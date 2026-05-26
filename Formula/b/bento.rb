class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "80fa66400a06cc9f1f8bba6822255fedbe02ad8e886071a54b5ef4648df153f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c8c46c6aca6ffd0f5e012403f6ae93bf4ceeb94b65796122122a84c5dc601ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61857f5265f447a71dfe9e4c4ad5b95ab00f2950ca2814cdda888377c116ec49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b02454780443a0790d3581427d704b5f4557990a8d625738fcead0252cac9f3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5983dc0b61790236ddbffb32f34a96542663d5993e94c68b30d46391f98179f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b11895f7dbd6e7a29731057af440363e95ab03eba740ee034a21f25f4eec8f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "647aa2bb44c242a8b6462c88b9c23a5974d757ff7feedf171011620948c36001"
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