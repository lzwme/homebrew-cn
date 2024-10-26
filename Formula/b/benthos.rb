class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.40.0.tar.gz"
  sha256 "4b062fdf8e28618c6485a644b271d829f4af8b5ecffba589bcd49dcfd169dcb2"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dacd7fd2241b530cb3fa5a6fd4c852f2b1ed4426a8fcda9d3f09835eb93dadd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dacd7fd2241b530cb3fa5a6fd4c852f2b1ed4426a8fcda9d3f09835eb93dadd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4dacd7fd2241b530cb3fa5a6fd4c852f2b1ed4426a8fcda9d3f09835eb93dadd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f01a7f50053cb0743999fc1666e2035358fe72508bb341d9fdab7772e9536c84"
    sha256 cellar: :any_skip_relocation, ventura:       "f01a7f50053cb0743999fc1666e2035358fe72508bb341d9fdab7772e9536c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a9c0515350a958840c2b7412a32abeabd80cc23a03c04adc34048074f04b7d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdbenthos"
  end

  test do
    (testpath"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath"test_pipeline.yaml").write <<~EOS
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
    EOS
    output = shell_output("#{bin}benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end