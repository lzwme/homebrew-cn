class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://ghproxy.com/https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "dfdef5d0cbd071dcb56ec5e5950658cf71cebdb008be4ec222cbb5a513e188d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7c7762a00fc9cd3bdf327471bcfeb32b72141cf7fde9c37496a024844cd9aee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d231c5920c6eaa6c2a31887e47d9caeb68629950a08c820d8b66bd7772e2b135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4df461dd46ada3bc980bbf3f693baae7241499bd6423796be9de6407911a6777"
    sha256 cellar: :any_skip_relocation, ventura:        "a96920e980cad59931051748baa2abf3badb03f7ea4260e60e32c064910738bf"
    sha256 cellar: :any_skip_relocation, monterey:       "9cb032b46c1800e5ad186252ff0cd08708039d6c3ab4d5d5fe418194cb370ae8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3115f9d2ab0d19864c21dab46ef7fc53a49ce92a2b935e722c52d33d2a502e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afca99aa214d0e235019e81123e241ffaa0eb24f61d3bb4fc1ca978fea79afd1"
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