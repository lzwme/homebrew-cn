class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.72.0.tar.gz"
  sha256 "0fd0c6c04b7e23bdfec3b4df1f4aa71fba5b9f261548606fa184ed642d553a78"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0569ffb81a5f78fa687815db8ed79027834779b6e26e6c53d5ee652f507b93e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0569ffb81a5f78fa687815db8ed79027834779b6e26e6c53d5ee652f507b93e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0569ffb81a5f78fa687815db8ed79027834779b6e26e6c53d5ee652f507b93e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c99fab134d2e9ae5c31a7f9d3c7661535ef4f10216c59e909ae27ccedeeb415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18abcb5a661a52e9fffb1c84fe964f824fcec48b70a4b9034975b0391654881b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ac1d085ebf03316e606ae7218140c805aea22b0c6ca6327e2bf2b2b08b4c78"
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