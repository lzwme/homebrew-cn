class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.77.0.tar.gz"
  sha256 "a15c0377a7d860227c4898dc72a0c9f3adc72c7dd70a94ebf4949318a5d34e73"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8dca23c82bdc3ada80550c8252ce2107e918ed54b2c8981cb7484a76eb5c8bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8dca23c82bdc3ada80550c8252ce2107e918ed54b2c8981cb7484a76eb5c8bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8dca23c82bdc3ada80550c8252ce2107e918ed54b2c8981cb7484a76eb5c8bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d339575749d3e58c189c1a9822433f4e94a39df97ae31fc02b3f8b58fdfe61ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877c405573c797d0fe2d0a8d9b6dd191fef797117f2cd5e84ca0c5a978014124"
    sha256 cellar: :any,                 x86_64_linux:  "158bdd0add15e108780226171f1599a653571b42c13d67159decdc1ea33d103a"
  end

  depends_on "go" => :build

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