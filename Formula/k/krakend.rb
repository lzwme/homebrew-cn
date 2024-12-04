class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https:www.krakend.io"
  url "https:github.comkrakendiokrakend-cearchiverefstagsv2.8.0.tar.gz"
  sha256 "c1b74db06cc2d410e132e51bdc92aacfd937099b74b02904a8057e4cb568dd53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf402e4f2199d6c2830db3b8c9e08494c3e0df89a4bfb54dea4de83fcb7457d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3abf39cddc8d2181e760a12c6a941f4268af9f5178ceb206ed19b69b4e85a011"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f6bafd31c69eebb93ec8cb3f3e485ec0915a0391b2c42e68a8ae9cbe4c5424a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d604ed878f098be3d6346b30cb88b58226b872f47ae255423124d7aaff2ca1c6"
    sha256 cellar: :any_skip_relocation, ventura:       "63930c10ab33d12bf2c79562be3ef37180c63190f3671bc9d8279b840dc04d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4028f3763b1b9fd4e6b8dbbba8555ea60e9f5ed34b1cab06aef6feecf52a2ad2"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "krakend"
  end

  test do
    (testpath"krakend_unsupported_version.json").write <<~JSON
      {
        "version": 2,
        "extra_config": {
          "github_comdevopsfaithkrakend-gologging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        }
      }
    JSON
    assert_match "unsupported version",
      shell_output("#{bin}krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath"krakend_bad_file.json").write <<~JSON
      {
        "version": 3,
        "bad": file
      }
    JSON
    assert_match "ERROR",
      shell_output("#{bin}krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath"krakend.json").write <<~JSON
      {
        "version": 3,
        "extra_config": {
          "telemetrylogging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        },
        "endpoints": [
          {
            "endpoint": "test",
            "backend": [
              {
                "url_pattern": "backend",
                "host": [
                  "http:some-host"
                ]
              }
            ]
          }
        ]
      }
    JSON
    assert_match "Syntax OK",
      shell_output("#{bin}krakend check -c krakend.json 2>&1")
  end
end