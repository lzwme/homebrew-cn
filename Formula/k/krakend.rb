class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghfast.top/https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "49b3333a2bfc707c5f700450b0ff11707b52e4c9e9f95e9e9b6f7d1ead7bc8ac"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "536af76e0b9f6f785fdc27e6e0c62b95d3414c219fcec1b72f503dc49b6acaf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef361a39497f66f3aed8ac5f73da1e5213a226cf4a98ad64135acc9594445903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b31b4c64ae941c43211da0660b5e3aae5609c8e3fbddfe23eae5ddb63ada62"
    sha256 cellar: :any_skip_relocation, sonoma:        "f038f9081de5403dfd69ce94e078ef9bd4058da1fe0fe0ce69dcfd3c4825ec4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da52bcd9adb8a285fd5ffd954fbd73e049d20c40f494157f0cd55a2ef05d493e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9d59dae84577c86a38ad677bd9534e9a6025ab343aea47635783bb3d631be2"
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