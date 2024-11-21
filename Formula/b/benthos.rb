class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.41.0.tar.gz"
  sha256 "0e67c9f266f7a7b619cbc63f55b55696d7c7f293e4525cbc93980dc1312aa10a"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "318f8b06e19a5286f1dbe8c50cf1afd65999cfc33fc20d1e64348e6445cd0987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "318f8b06e19a5286f1dbe8c50cf1afd65999cfc33fc20d1e64348e6445cd0987"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "318f8b06e19a5286f1dbe8c50cf1afd65999cfc33fc20d1e64348e6445cd0987"
    sha256 cellar: :any_skip_relocation, sonoma:        "026a1b3ef02a84b4145a7a4cdb47c43e71fd5ec38110eff53ec5d05070993ed4"
    sha256 cellar: :any_skip_relocation, ventura:       "026a1b3ef02a84b4145a7a4cdb47c43e71fd5ec38110eff53ec5d05070993ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e9ae37fc0063c8de2dc4d05b0ae44a93dfae9596696200d1ea341645360dcf"
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