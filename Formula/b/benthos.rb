class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.55.0.tar.gz"
  sha256 "23c553706f357ff811670a4989ded281db0b92e5cbd1551a3b6e78ffa22806a2"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2f30712742f9a6897d3c36f8cd897a153154a992cab7341a13aa7d54163faa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2f30712742f9a6897d3c36f8cd897a153154a992cab7341a13aa7d54163faa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef2f30712742f9a6897d3c36f8cd897a153154a992cab7341a13aa7d54163faa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade909e5a80e88d7f602a262276430b3b17b52490cea3506d0cec677770c01d9"
    sha256 cellar: :any_skip_relocation, ventura:       "ade909e5a80e88d7f602a262276430b3b17b52490cea3506d0cec677770c01d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3c0955e48acdfb0e098ee5dc9524fb983acdb1fafbea8ef5435fd75f80019bb"
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