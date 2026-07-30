class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://ghfast.top/https://github.com/thanos-io/thanos/archive/refs/tags/v0.42.3.tar.gz"
  sha256 "cdb2b17c9a6423a5bea2c44ce7d8bd6b71bbe385c5812027e6dd2db6f61beb1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "082efc3c6dd1832d484b1fff5b3be5bfd85b6a8100e03db1c9d5b74e66d92c18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "255dcc2d7f175862f263639c409992ffaa49c96ae261e148bf8a423bb81d9091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0b6dbe52148f3d185fd3f5d75525bd310004505a80212709c10fb7da5f9adf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "92b1537d4c25d00351ab616ed7fc1a5dab38ca429c1cf7e893fbbf8597dd2db1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5466af4e280a75c5defeeeb586648f5d21447d7be4cd3fb79fcfbac51690a6f0"
    sha256 cellar: :any,                 x86_64_linux:  "d78f39c17b7d5345286065648c91cb80350057d72483118012bd9d1c5f1241a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~YAML
      type: FILESYSTEM
      config:
        directory: #{testpath}
    YAML

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end