class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.44.1.tar.gz"
  sha256 "a9619de43e7cffdd02c27049e2eb389c4859c0ca4e70c69edd58505904bc26df"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79690e246af7f7520a9abcfeb6f59408f527da9ca031e33892edd77e1749f8ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79690e246af7f7520a9abcfeb6f59408f527da9ca031e33892edd77e1749f8ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79690e246af7f7520a9abcfeb6f59408f527da9ca031e33892edd77e1749f8ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b54e0ceeabaf2b3908d92462f3c36eaa0db67a077bbc250171ea9846fe71ba0"
    sha256 cellar: :any_skip_relocation, ventura:       "7b54e0ceeabaf2b3908d92462f3c36eaa0db67a077bbc250171ea9846fe71ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93c71cbd6e4d424a7971ea0be3651def5a1011ba7d75c2accbd58e48e9cf3a1"
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