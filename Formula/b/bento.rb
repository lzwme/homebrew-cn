class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "674d91eadcea94c4d3704ef36e05cd7b7631e658df8cf1f21150911fdcd724da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40ac3ed28032e1ea9f96cb23c58e4a25565f5b1fb2a83a6cacc32a25fdca6d52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1be36b6bcd6234c4a06d7002af131c400bb54052a03c843365591017384d4634"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f8c95dc9ddd2fa7c7938d371c31a0b982f08774cd6478e7fe29a7c9523c3c1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a320407c83f91ce5510a25a8ff1c29c8ea43f8215a9700c2e028530b300354c8"
    sha256 cellar: :any_skip_relocation, ventura:       "9c65bfb2f06f459783e56a573459f1eebc7450d06bff4a3efb088c29092e9bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab88fa6bd2b9ca99427fb8bc0484b4aa8a2886e25c997fd0a9bced1cfd6998a5"
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