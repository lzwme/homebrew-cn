class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "93d9c37e6c14e4a07a39a22ddaa150247215752b2c4ca9030eef031bf75b7dba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89b96940fae0ed6561ab1d79b2f979a4dbd6893aa5d6ddcc0013b1921ba23e81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c89c41b5ba5a8b70391f5633c602c2d628c4d2f60f523357500d6bedb910aa1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9376723f3eae2af0db7c3a8484528cc56b1dde6ac6f6414b18026c05aa79ca0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95085095cd91950500d99243ddadbce40c91fb624b46f73364363d9abc87f4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bce1e82922dccf3e8bca866915346f80051d430e78ef817d52735f589158b34"
    sha256 cellar: :any,                 x86_64_linux:  "4ec41f6c3d4c4797181674c9f61b1752bcdaf0d99c14410cc455b00192da47f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
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