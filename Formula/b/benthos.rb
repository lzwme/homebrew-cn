class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.67.0.tar.gz"
  sha256 "e572ee419b0f99f24587d3c62e730ecd1d0eea5af1471fee421ced88bd482c78"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a51daabb999f9beced4394672e8f7e36d8ad500e84850692dd2c244ab761db81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51daabb999f9beced4394672e8f7e36d8ad500e84850692dd2c244ab761db81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51daabb999f9beced4394672e8f7e36d8ad500e84850692dd2c244ab761db81"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bc7aacb78bb3163c1829210d264066804c61d6d31d6fa18dfb852b26731ae37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04f0cc06fc5f8f44995d0a586ce32098b9ab340dc075905580bc767fd99ced23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b41802d0353f50fdd5f223c39111d5b951f2235ed3d47105ec631e93ad6a9b59"
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