class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghfast.top/https://github.com/krakend/krakend-ce/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "1e768c4560dbc106d248081b27cd36b7029a71a808aebc42ed80e3873c074563"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f709a1abb202cc0c011c50b72e4386dd65d8bbf18e4b853396355e258345a67f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4e6638fb05cbab46ce1024d0c8f1970aa1ba55202a4f47a8b677da74656fb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85510904a5d16b292ca466786fe4a9c3b3355d77491f17ff85cf450c4c228d13"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f89aabb9c0260bd3fef11d8f3dadc01499b42a0a3c43523adc8b55e4ff4951c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9fb232cfe22d951a780877814bdddfdb435ef84fd4c7b33d6cfef5605f61d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f33eb6da04f917329127e5a340214b91d4af0674bb9793faf2c381c1f710df"
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