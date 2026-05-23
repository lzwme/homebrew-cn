class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghfast.top/https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.6.tar.gz"
  sha256 "0b0fb7cdcda964c0d440c62c6065c50fce70a534b702c9ff82f33bf0f85f9f0d"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a9e26248e46a9fa10ef2ff42d336b585b8841cd229f308da2ba6d20c253f026"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "341fc7eca96586880a1779c95b306ab5708ebc91b4d3a3935ce44d5c33aef86e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8491227690bdeb87ada384b4559398d00c953886f02d49091199eacb79b3abaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f68dfe7b1676c616d3a23978be14d28d0e9c2492a847b98d1d07e3ee456df429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf93164dc577ec04d341cd16d81da08b067e60329421d9b32310950259735434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed1e232d87cb60eb6dbf0f82aa6730940a54fda97a84905d23749946146e457"
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