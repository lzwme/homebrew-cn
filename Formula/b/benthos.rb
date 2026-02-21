class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.65.1.tar.gz"
  sha256 "df50a0605e69813b9ae2b05c60c6228e17f082167694c42201e90068892e6b95"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cb886c038b0897349a33608311a9d5f24b3b283f3abce24494daa22c47c9793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cb886c038b0897349a33608311a9d5f24b3b283f3abce24494daa22c47c9793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cb886c038b0897349a33608311a9d5f24b3b283f3abce24494daa22c47c9793"
    sha256 cellar: :any_skip_relocation, sonoma:        "d43263c6c39e535b9bd9f7aff462dca5ece76a6dc581f54ad881abbbc0783a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee788069b2b3ac8459cb39cf88e54031dff3357d4b3eedb5f9b3ead9446b3c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384f8d54dcc235d45a0a6ee567cec46f258c461c6e33eefaa5be5a00ded541ab"
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