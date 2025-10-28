class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://ghfast.top/https://github.com/thanos-io/thanos/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "ff8a7ea742c46029041a8e56807d979314e96fb2c81fbe0fb9d50982cbc5928c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0502c04124550cd4f8e4a62e8915660b80386687c1d8e6cc22cbb237c5d31562"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597f59fea8d778eaa6529413e98e444afe2b07d81201ced79598d30a53710264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "282ba69564f2fc9fc806d9dfa1b87f5385d8462233b91bc255bdb3beb6d13a5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f733d1c037de6492d903f339c4f2e3fcf1e0864acd25ca10d358242f5eb21e55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adcf442060797dc473d4da77a410566c1749581e10f35e7ff46e0c5a85d46c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "404d0b49e5bcaa3d6a3027780d9da3fddfd61ef2f7b9677005cfeb84306d5107"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
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