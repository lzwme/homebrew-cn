class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.59.0.tar.gz"
  sha256 "e91734f31a58e133cb072a88b79cd5f2aacc25b61355597977736c5445d2c8fc"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "398d8bfa4fe48763e7b3ce3111ffae077ecce60bd0fc96c4cbb5148c60735c1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "398d8bfa4fe48763e7b3ce3111ffae077ecce60bd0fc96c4cbb5148c60735c1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "398d8bfa4fe48763e7b3ce3111ffae077ecce60bd0fc96c4cbb5148c60735c1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ecf3ab8126a746853132d6191228f33597d9792eab9be57409bfe772222cf6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1c375a6f5ca7a73d858671dc7f6d7ac523253b7a4bdce447382359823767662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fab59babfe02593f098547f5dd86ce0d392e08ed160e5cea4d7e6817671790f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end