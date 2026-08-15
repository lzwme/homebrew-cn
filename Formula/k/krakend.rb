class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghfast.top/https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.9.tar.gz"
  sha256 "12b91ee5583a960e492fe2438498fec580ee352cddead3602cd8354e8bf00122"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8102ded1f8d0f3faf16b113f4409a26546dd0a35143822bafabd8ab292f7cbfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37796af463d2306f904ca4fd37643d3e20f565a848f2e306ea074f48d6069526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ca1261d3b114f9c970861e002e87066ef7e4861ad656c200e107a2ed2237a5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "43487d9a4e8386683db149f23bf739051845f30650aa803ca4a7ac80611dfc76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83976724959504ac27f2ec52e951f61f4a3ca32d406e416735938f303da4873a"
    sha256 cellar: :any,                 x86_64_linux:  "164ff8b5cf7c7213d9aa21526821da7c91c71d7f70d5c38cb0e957c8998a00f6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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