class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "9db04e0d20786e949866a9ea92c2ca3056e6aa12efdccfb62b2ce883b7fa4326"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e72aa9d534e2e93152b23c29ac9045a6ea84171dd688683c33adffe957b8634"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d08bd010d9cbf9fb79b598c8630a3a08699863bcce4d1698ca0457fa4b88904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c89397b0e262a55cfcdc8f500fb85bd6077d90e63b927cc38ffdc7cc0bb1b825"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c4d416f4ee38d46625a5e52627eac52d4c6c30fa3c8bc09f04114ad430b512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a6f47b876ac6dca703e3f25bd0e0d15e1eba5c5ea30fa2d3d7ef181f9201ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771b0d636ef11bd3242419f103c9eeec225cb7933688b48eca838c1318490a1d"
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