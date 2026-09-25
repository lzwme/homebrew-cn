class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.81.0.tar.gz"
  sha256 "01aa9ee6f477ed3167cb1ee6a869bc6501f0c0bd8d06129244346bb5ed3f9d74"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b868e363d2c04b0944ef68fdfb076309e5f109a928e42b600db4fabb9de10182"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b868e363d2c04b0944ef68fdfb076309e5f109a928e42b600db4fabb9de10182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b868e363d2c04b0944ef68fdfb076309e5f109a928e42b600db4fabb9de10182"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "539ec43c9dd3e80a746ecb03955dab1379426abe11003dad1365f637c7c1bba7"
    sha256 cellar: :any,                 x86_64_linux:      "2f0647fb4654b6323ad69ef7adafe337824b79b54d6e720c9959e07d4b17c7e3"
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