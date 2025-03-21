class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.46.0.tar.gz"
  sha256 "405692a32d823699e295a292b95b9b38994dc0ca8633632a477f31f71a631b33"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99f941784bb2886b14f7345e408a2d1eceef99b1353bbd33499d3065f801cacc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f941784bb2886b14f7345e408a2d1eceef99b1353bbd33499d3065f801cacc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99f941784bb2886b14f7345e408a2d1eceef99b1353bbd33499d3065f801cacc"
    sha256 cellar: :any_skip_relocation, sonoma:        "89f7d260a871d684fa83b4e149e95b156ec58e9317b5792ed6a9c801f603dc98"
    sha256 cellar: :any_skip_relocation, ventura:       "89f7d260a871d684fa83b4e149e95b156ec58e9317b5792ed6a9c801f603dc98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75a004eb0cc354f2055d9476a907fefc160196ea336156a8503f6092fbdeccfb"
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