class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.82.0.tar.gz"
  sha256 "304d394cfd96c7922edddf645bcbed44bb4d115e4e8f33a3c19e6b00484edc77"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce5f78f4435fa2484e040afe673d32b2ad150d0d4e30a0febdc01b184c60b271"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce5f78f4435fa2484e040afe673d32b2ad150d0d4e30a0febdc01b184c60b271"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce5f78f4435fa2484e040afe673d32b2ad150d0d4e30a0febdc01b184c60b271"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c5d8b90026ebd7647c70372ca35f610af63cdabfa68a86a72a19555b3c9d93f5"
    sha256 cellar: :any,                 x86_64_linux:      "7f74fc75868fa5c023bb92629a851c60b7d54daa803b3e656877d1f107061a31"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/benthos"
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