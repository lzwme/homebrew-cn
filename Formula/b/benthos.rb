class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.58.0.tar.gz"
  sha256 "2e5612f7f2afb7f73070bad2291a79f154ec4561a6e1b91f993093b4b7beb42b"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba32755590003ab105798ad288592e0e76b01c30a8199ba0939d5d786911362d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba32755590003ab105798ad288592e0e76b01c30a8199ba0939d5d786911362d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba32755590003ab105798ad288592e0e76b01c30a8199ba0939d5d786911362d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e152c4a4a99609ef6681a53270b162c6bb98e1246a82f4ee52abf8eb38155522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b8f839d5481265c01c5c94ca62a11218542b2ce4d3f2e71bd71e01c7717469f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dfbaf1112a1f27fcb085a4437ac3221d8cbf60716439ebd57e534a483938c46"
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