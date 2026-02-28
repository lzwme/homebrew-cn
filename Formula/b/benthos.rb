class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.66.0.tar.gz"
  sha256 "5fd338c2622b74bf5980945200403caefd02ed887e7c124259c6aa35cc238bbc"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629d37302f39ed1d5174bcace12f18b496c3bc4669157843de2d18212e2f873e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629d37302f39ed1d5174bcace12f18b496c3bc4669157843de2d18212e2f873e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629d37302f39ed1d5174bcace12f18b496c3bc4669157843de2d18212e2f873e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c25905f7ec39c19fb7e5d5e795cfd927677fd8b75b8fb43527fef6c16ba58b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6f28cb87b2f2ada956ac6105e14d190e1f067a48ac7ae1830d58e6c4dc450a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d884be6012707a13beef2dde1e462cd8f46e32e0e363fa9c48e6e030fd0fb195"
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