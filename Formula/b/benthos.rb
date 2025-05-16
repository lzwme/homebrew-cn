class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.51.0.tar.gz"
  sha256 "8233ea6296a1230e388cda29d9f4d4daca631f9c7baf3cc8df484f15a3503b7a"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a07cd20972e93a62a7ae6362922a2cec2c0692ede4ff0d5afcf7b6fd38f484c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07cd20972e93a62a7ae6362922a2cec2c0692ede4ff0d5afcf7b6fd38f484c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a07cd20972e93a62a7ae6362922a2cec2c0692ede4ff0d5afcf7b6fd38f484c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4347d23bc899aa3e0a5cca434bc7117452d024a4477d574e50e342b880f92fbb"
    sha256 cellar: :any_skip_relocation, ventura:       "4347d23bc899aa3e0a5cca434bc7117452d024a4477d574e50e342b880f92fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d13641fcfc18e519db083c9ef2172c448d3cd1903a15e339543e4b27ac0eb934"
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