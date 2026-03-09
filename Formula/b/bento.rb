class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "e0b50a73c38fa01cbf5fdf3501ba47a066d41b20eaf30eb61ffe0e845a8451db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23119836a1eef29951db8a5dd6c92e2445e1426ab89599329a5ad59140e9228b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4633eb316ed831deb9143704e50fd690feb9365738655accb3f23f8885299d6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e72698315d7ff5b52d8fb83af80ecc6c41622cc665dbff248b12cfd338f09f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd8966ae77cace68e078ee0ae285db6cc666f8e8462f859bf7b7a2ef1181e1b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acc8ef546998bceb012a26e8ca2f3b588f0da8fa610adb3cc9dda2ced406ebb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e0b2d485cdc6d177de751c9bd70aec52700ea9e28e670681f08921f0820d99a"
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