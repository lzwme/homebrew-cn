class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https:www.krakend.io"
  url "https:github.comkrakendiokrakend-cearchiverefstagsv2.7.1.tar.gz"
  sha256 "a822ee0c7300fe1324f3b9915283d947756a070ec6ec10fb96115774718c159b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef127aa8943d4899b49c7303d2fa353ded0b9a3fe8c0557b4a36d8743e9dfae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc9e4d3cd0f44ed45a7cb8503998c361ec5cca3393e37e149837a5bfa8e2931f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb8366b4caad99c8e73e243cb4e45d86348aa0b31dfb49091fc35f1a79d3838a"
    sha256 cellar: :any_skip_relocation, sonoma:         "51b3d8b8dc7d05115d2f253c3a4b79cab9329ac83438a04052ab4a46d28cf5b1"
    sha256 cellar: :any_skip_relocation, ventura:        "b6f971e925d442aad92d354bcd1179fc1f1652abcb083829a567f2fbba8c2f3d"
    sha256 cellar: :any_skip_relocation, monterey:       "2f57dae2a8ec61a1e0a0fa643c19ec80b0f084a48066dd8e9c5c2bd43858a2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83aa5b7c3051109905ed78fd470b713dca567792a1d6b889c26b626471eb8459"
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