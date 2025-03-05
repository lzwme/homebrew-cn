class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https:www.krakend.io"
  url "https:github.comkrakendiokrakend-cearchiverefstagsv2.9.2.tar.gz"
  sha256 "68fb4ce3fac45e43656660b24164fe479cbb22d0a8bdb622c16030b1a5931c26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "342dfbd317781d7792329e68dbbf714be6919e1577cc8f0f8fcf3ca5aced8205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28a1d1fbb9dc103dd398c178fc40be5f0caebb488847ee0bad767a271af4801e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f69fc41a867daf353580b477a07ab9995c1c5f2611043f9c40444c421717fda"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecf794ee240d7362e4f7bf2428a2e6f68768d645c9f07bddf7f2e2b9de971078"
    sha256 cellar: :any_skip_relocation, ventura:       "b1ecb1d1c1f2d8c6b9d743cd2a724fb93c0ee235efc0e6302d02445c4d006649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18ba69d5bd1844a864b3d083292912edae423ae3058d3c00d516fcb9d9e1a2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkrakendiokrakend-cev2pkg.Version=#{version}
      -X github.comluraprojectlurav2core.KrakendVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdkrakend-ce"
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