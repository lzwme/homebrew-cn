class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.49.0.tar.gz"
  sha256 "234923106cab0837e4983eadee0a1cfef3ff4edcdd6d02b69ad898c6a3746e71"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7950bcc4e58356c7b0940ba98cd254bfb3cb7f5a9fb21e0cec3fed620252f85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7950bcc4e58356c7b0940ba98cd254bfb3cb7f5a9fb21e0cec3fed620252f85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7950bcc4e58356c7b0940ba98cd254bfb3cb7f5a9fb21e0cec3fed620252f85"
    sha256 cellar: :any_skip_relocation, sonoma:        "318570936c659b09bd79dca6a5f6762f72de5f10640c55724968457c66c4c20e"
    sha256 cellar: :any_skip_relocation, ventura:       "318570936c659b09bd79dca6a5f6762f72de5f10640c55724968457c66c4c20e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbae08e72874be9bff1c1690cad7bc19983720f03b49bbea6e9d0f79ed8dd7d9"
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