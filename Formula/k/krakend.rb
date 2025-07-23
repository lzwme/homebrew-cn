class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghfast.top/https://github.com/krakend/krakend-ce/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "af027e0bef3d69d5920c1d85b5235074c46b955e89e328a3fb627e0df4a379f8"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19a57d25bd1f8de7125c840e9f6e1ee792f33613a3d97a2c7b4705bdd8a76d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8442425dd4b7291cc34e4d9898ce6df5ec419a671ed3cb7e5e24f90082fa4a41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfd1f923eaab46896846bf9f55975488185f6df0d5199c1744f99103651c665b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e6b6a65b01b7776a0c8af860889e953940f30bb0590b64ca687536851f6ebc8"
    sha256 cellar: :any_skip_relocation, ventura:       "557f6ac3a82c46cd55d0afc552bc869695cf44e8abb442e9dfa1d6f2dc28a327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6dfc2ef6335910ace383bd6e4422b56f4db3192d6bc8172444df5caaf51b94c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef8ea192d571bd05dd25b8e61edb724ebbe7d2aff39b7be99374c36e093833f"
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