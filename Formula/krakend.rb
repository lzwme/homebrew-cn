class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghproxy.com/https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "2f535d4428dbea97d0a53cbad55ede1e39ad71454ac33ba9e2e5002d67ba56b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "088304be3e433ff6703a7aaf07e49e0198787d7762552f81f145559509c26e4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62b466bb3822b25755f65bb905cace8e58c6a446361d20e5b0db4e513def6d46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad7302c68c6bf299a3f0e1a921d7f95758e1565b660c4399012a3da9f1e93528"
    sha256 cellar: :any_skip_relocation, ventura:        "993e9cd9495a02569cca812d991e49c7e51ecde85848563e3d58b4cec053d9a1"
    sha256 cellar: :any_skip_relocation, monterey:       "2a9602e45042660ebae7c799e8fa95445de36eeede39f48d7699dfe7c88cefb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0673d1eac191ffa42a8e13bdee52cbe27671a71e05ed95e9a86cf85be5b32e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6027e2f406b6dff5d497246c5964f79d31407eb3c8844fb67e4395fbb8c0358"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "krakend"
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~EOS
      {
        "version": 2,
        "extra_config": {
          "github_com/devopsfaith/krakend-gologging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        }
      }
    EOS
    assert_match "unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~EOS
      {
        "version": 3,
        "bad": file
      }
    EOS
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~EOS
      {
        "version": 3,
        "extra_config": {
          "telemetry/logging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        },
        "endpoints": [
          {
            "endpoint": "/test",
            "backend": [
              {
                "url_pattern": "/backend",
                "host": [
                  "http://some-host"
                ]
              }
            ]
          }
        ]
      }
    EOS
    assert_match "Syntax OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end