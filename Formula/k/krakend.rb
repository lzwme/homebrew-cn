class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghfast.top/https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.2.tar.gz"
  sha256 "3ca8bea7e86d956b0351abae224bb323b7a4e14af65524ee2a0b4a4503da6a9b"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53208393cc9df5b5952e60d87031a601ad58c9e3a99c31c6e5835533b771e01a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ad3902a4047d062cf154c6cb79747ccb910cf125324f4c063ccab8473a38a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6188e8d9130a7a005c4d2bbf1927ee1ab6016a78ee523f0bc79c21d526621707"
    sha256 cellar: :any_skip_relocation, sonoma:        "154c9970e27530afbdf4d9f72e90c52e347315a48c3548b847083e6cb2ca8420"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f50a6e60b9f79a824c7a4f5ef87f6dae5d69a790dde6d35d5c9daa09333e40b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5beb23e01ba47798dbc6fda4716df22a30de54371d0531914d4baf85ad230f98"
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