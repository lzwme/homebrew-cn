class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "64edad150e86179755c7f427a7cb477add5c1fbb066e1d3cc70b864977a58fb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e555d55744e192716a46d112cf3bf55f46e011be3f3a407e8eb49c78d0fd56a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00f40084f1231625cde7a413a05e3c901c174633f08ec7efafa158df2f22e50e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b01222136d33a3f421d94513e25e10f94cd2b4c4ea08f32ccf3aeeb63d1fec3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "db29bb1662978303c660b49764c3fda4d9055aa3ac6259667787ff24021b1b44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c49aba507963002fa6bce72eecc9b193cd338b534d3fa3e5b76095806a0068e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c55d6fefe2a72724b500b08d6251e52ccaa43e796184318879a08206b002ac65"
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