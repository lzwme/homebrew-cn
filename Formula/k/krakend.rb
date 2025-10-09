class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghfast.top/https://github.com/krakend/krakend-ce/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "b9fcecf96a393f267c2cefdb33a3fb7b142fb3cdefcd4543f799773cd3c91b7b"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d5e5717789f3ca6df9aac8fba55039e882b54d6576b46498b719072f768b7cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d6ed50b37b759ac074900b6fd3a106f7b24defb39142f7b4a8dabd35b67e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "913bbcba936565a8df70356dddbd2818ba483599877553de1f73f2f9f6615284"
    sha256 cellar: :any_skip_relocation, sonoma:        "884e784b64a0fe6115653f322a7c5ace2b2c070d2bba5e94878da8be316c08e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d55e7c85dad4f050e41f2c5baf50f3ca6e9ad9bc40955f51e4ea564107bfaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "720e0ebdf57d373a9235ff2a4de1a61ae475f6156ccde4343404bf5a040f808d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/krakendio/krakend-ce/v2/pkg.Version=#{version}
      -X github.com/luraproject/lura/v2/core.KrakendVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/krakend-ce"
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~JSON
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
    JSON
    assert_match "unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~JSON
      {
        "version": 3,
        "bad": file
      }
    JSON
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~JSON
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
    JSON
    assert_match "Syntax OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end