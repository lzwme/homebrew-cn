class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.34.0.tar.gz"
  sha256 "8cacea4f8985d3e9a950c34b691287fcc6672a54279f9f5b9670c899754f614f"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2f6b1adc8c5903c68583933ba44d73444da95513f2d440c673ab8adae37b495"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3930c626736f56a02eec17b1455d1b6bedde8c760cf5e918af9041e15110873e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "381d49e2a24b506b24d85d921fb7ce931bb17a5f7d08183b0d71ea621b5c0cc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee22462bd80d5ceb9add7470624347165610c46054b381303997aac7e9f6a860"
    sha256 cellar: :any_skip_relocation, ventura:        "139e22b90802bc8a8e49839e5c909cb17c3473042712c98b8451b30640302960"
    sha256 cellar: :any_skip_relocation, monterey:       "bf46a21f08291f082b504a97fb08cae7d4d68e103b4e5ad3af5a58531c6f3f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a933b36fd2e634721c7b383e6118463467ed88bc27e838305075a9b858d83e4f"
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