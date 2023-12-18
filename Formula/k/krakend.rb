class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https:www.krakend.io"
  url "https:github.comkrakendiokrakend-cearchiverefstagsv2.5.0.tar.gz"
  sha256 "6dc08111719256816a4d27bb250803f48e0b628168c5b2132ae8e0829380dcd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cb2b58ebe08b34c421420e42efdd6b14acd4e85c44fac19e67e1922be46f377"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9194ac43866492c3c100ac240cfbc6a514b70d45a4e5a44db0779fe98dbc1d78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5de03fa0c13a9324af902bfe8088506c3ae08b3be8a5ace19e60b1f78a716b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "976526002d3ab1ef29d81225c2c5529d45945b03be36b927f4d5231811d0b07c"
    sha256 cellar: :any_skip_relocation, ventura:        "2a540997c7c52183b0c8b1553c83b965d7c5c9185ca64f95a13646d4f37a02f9"
    sha256 cellar: :any_skip_relocation, monterey:       "7898650ac53986854824b6c0d3e6717ec2d329e750f3d68014257df3ff601e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3063e4a1356ae7ed2bb202ea7e7a168a8d749625b4f5e63273c54c17405bc6ab"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "krakend"
  end

  test do
    (testpath"krakend_unsupported_version.json").write <<~EOS
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
    EOS
    assert_match "unsupported version",
      shell_output("#{bin}krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath"krakend_bad_file.json").write <<~EOS
      {
        "version": 3,
        "bad": file
      }
    EOS
    assert_match "ERROR",
      shell_output("#{bin}krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath"krakend.json").write <<~EOS
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
    EOS
    assert_match "Syntax OK",
      shell_output("#{bin}krakend check -c krakend.json 2>&1")
  end
end