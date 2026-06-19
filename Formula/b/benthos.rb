class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.75.0.tar.gz"
  sha256 "a789e436c945b14bbd1d5f82546ee21366f6db0eed07e4e9cf62c6d1420d4a92"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e295a6e8e0ad3ea4b662067f5868509556c864d9cab077721305ef14afeff9a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e295a6e8e0ad3ea4b662067f5868509556c864d9cab077721305ef14afeff9a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e295a6e8e0ad3ea4b662067f5868509556c864d9cab077721305ef14afeff9a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d0efc0c4b16e63c73f5b77ece899c28ca1d4bad5ed9bbe11519149435b7ab94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a8a0a5d4da53a56f27c66cec2746037b17cf58f398b77f7148a4e80a79bdf05"
    sha256 cellar: :any,                 x86_64_linux:  "6b126481d1743543b6086a71719fb92999f795210a7765fd87080a84aa68431e"
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