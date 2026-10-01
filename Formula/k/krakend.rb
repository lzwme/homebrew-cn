class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghfast.top/https://github.com/krakend/krakend-ce/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "d9109687580c0c3133e80759322dd2b4699579c0339ae91039b0779eaa8534a2"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5728d94be5932aeff15fb30c35e55a5e3445021f85df159d7eaae41060372f3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f4771fe91b01eec03a9beb7f0a8e1e9b1add1a81b2087577d01868d95691afa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c1375580bf871f466e4a5e4a5aec61c29f30f77115b6347e5a55350fc963010"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "33f86bdc4cfb4a22b74cf52a7be2fedc20b16c32dadfd6c510b656bcf9e4b8aa"
    sha256 cellar: :any,                 x86_64_linux:      "45af5db5ab0788842c5e1a0a99b8397c5fda9552ecd18da45997c8fd1b97d893"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/krakend/krakend-ce/v3/pkg.Version=#{version}
      -X github.com/luraproject/lura/v3/core.KrakendVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/krakend-ce"
  end

  test do
    assert_match "KrakenD Version: #{version}", shell_output("#{bin}/krakend version 2>&1")

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
        "version": 4,
        "bad": file
      }
    JSON
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~JSON
      {
        "version": 4,
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