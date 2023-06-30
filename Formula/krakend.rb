class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghproxy.com/https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "b6cab337029b344c0d8f833494de210437872c9ec3ba777d08f9176ccb7a0c8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea1cff0b0f3589114700ae42a6f18fcb743c0e6552bd613d9183980191daaf68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b947be22bfe39f4b142c80d9cf92720a798e93d361d2cb64e8e6c13ad90fece0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da2692019c8097f76d9991fac747fababb19083d3bde0b9d5ee820250940491a"
    sha256 cellar: :any_skip_relocation, ventura:        "d945eed9f6e17c31ed484ba2f1aa2754f0aeeabe45017fe3761de076fd6c6d50"
    sha256 cellar: :any_skip_relocation, monterey:       "65e884d23bd0c0871cae123a49c8788d3c0e6bffb0ad007b1b29df7ef9d95c06"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1750521f795acb65fe02e9b4b8118fb3d88390949131755709a374d9c5b7af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f89ea8c0be833d46ebc55eef179bfaa6bba5f756c9d8bd24a5ca0c1739d1281a"
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