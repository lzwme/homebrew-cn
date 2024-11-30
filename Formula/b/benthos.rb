class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.42.0.tar.gz"
  sha256 "66c76065668a3ade672504a82d2ca5ff070610396909170874f4ad24eb6763a1"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1d913ea33c427dc6235d27116dae57bf979a49aac82bb9ea746b613a1d831e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1d913ea33c427dc6235d27116dae57bf979a49aac82bb9ea746b613a1d831e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc1d913ea33c427dc6235d27116dae57bf979a49aac82bb9ea746b613a1d831e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c79be3a7f7a1928a6785e2b7fc59a51ec91de54142ba8ade059088c43c477a5"
    sha256 cellar: :any_skip_relocation, ventura:       "8c79be3a7f7a1928a6785e2b7fc59a51ec91de54142ba8ade059088c43c477a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbea15871ce606f75353b5d788c691abdf31afe5999fea701bcaa32e2399795d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdbenthos"
  end

  test do
    (testpath"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ .sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end