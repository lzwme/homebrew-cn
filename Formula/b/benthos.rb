class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.68.0.tar.gz"
  sha256 "5bac86829eaa220f2be1769f5a714eb2a68d6b146cb2d775915b06f2e84e2782"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "397b38eb86173c5b4a48a6600892b2e4a1fba9dbe536e1145171abd6bb3e869f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "397b38eb86173c5b4a48a6600892b2e4a1fba9dbe536e1145171abd6bb3e869f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "397b38eb86173c5b4a48a6600892b2e4a1fba9dbe536e1145171abd6bb3e869f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a644523be26b217aea77f320c6b47d3c399a75f17bb94c8b36651fb71c50cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f06cdcd2d506b8c2ac1cdbe3a6962c0e2168137805c6f5eb58aa6581878b4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e83dca5ec5a2f6002269d3954ea344f6942a00da966c3c14c725208513aacb8"
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