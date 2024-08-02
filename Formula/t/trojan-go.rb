class TrojanGo < Formula
  desc "Trojan proxy in Go"
  homepage "https:p4gefau1t.github.iotrojan-go"
  url "https:github.comp4gefau1ttrojan-go.git",
      tag:      "v0.10.6",
      revision: "2dc60f52e79ff8b910e78e444f1e80678e936450"
  license "GPL-3.0-only"
  head "https:github.comp4gefau1ttrojan-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9872077ff3a1ef7d427cac872b6b1ff7d3cff029c241e35a884e4b4a090e163"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76f3e955eee77490f3104b14685a116a56697e78a77cd681a2161ae1889fc251"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec98c6b4c3d8848c7f4f509b2dc0597ced55ca1345e6cb7df3db3cc61e8806ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9762f85a824ff74c47da792549bee3b227c3abdc0cdb0e240cbedd353aefdfc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ad928d61bed0387e16832906b26d2f33cbb38bdc432f2fd9926c8dfb0803265"
    sha256 cellar: :any_skip_relocation, ventura:        "88774cb71364936de995b60f0814352b844a0803b6da516def65ad0a5faef2b4"
    sha256 cellar: :any_skip_relocation, monterey:       "0e62938f7a9e79f03a657c4fdaa0399bd7b619043bc479bdb593d27d52bd37c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbd2c6728ed016b1edec17347f6afb7b2c963838785e9579c597a84c84760782"
    sha256 cellar: :any_skip_relocation, catalina:       "032789eb1b094143bb9e0ff9ff2e322b4bed0e14e5a475459637dea749771a2a"
    sha256 cellar: :any_skip_relocation, mojave:         "938d529de6c2e30510d85e21a15507d1dd25c2775e4f15a23f3ebfe341403d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d97afc587b2f38bb0bd46c0ed9adaf6d76346ac92c42b7cee5b959f4a0f0b7b"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https:github.comv2flygeoipreleasesdownload202109102251geoip.dat"
    sha256 "ca9de5837b4ac6ceeb2a3f50d0996318011c0c7f8b5e11cb1fca6a5381f30862"
  end

  resource "geoip-only-cn-private" do
    url "https:github.comv2flygeoipreleasesdownload202109102251geoip-only-cn-private.dat"
    sha256 "5af05c2ba255e0388f9630fcd40e05314e1cf89b8228ce4d319c45b1de36bd7c"
  end

  resource "geosite" do
    url "https:github.comv2flydomain-list-communityreleasesdownload20210910080130dlc.dat"
    sha256 "96376220c7e78076bfde7254ee138b7c620902c7731c1e642a8ac15a74fecb34"
  end

  def install
    execpath = libexecname
    ldflags = %W[
      -s -w
      -X github.comp4gefau1ttrojan-goconstant.Version=v#{version}
      -X github.comp4gefau1ttrojan-goconstant.Commit=#{Utils.git_head}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags:), "-o", execpath, "-tags=full"
    (bin"trojan-go").write_env_script execpath,
      TROJAN_GO_LOCATION_ASSET: "${TROJAN_GO_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "exampleclient.json" => "config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}trojan-goconfig.json
    EOS
  end

  service do
    run [opt_bin"trojan-go", "-config", etc"trojan-goconfig.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    (testpath"test.crt").write <<~EOS
      -----BEGIN CERTIFICATE-----
      MIIBuzCCASQCCQDC8CtpZ04+pTANBgkqhkiG9w0BAQsFADAhMQswCQYDVQQGEwJV
      UzESMBAGA1UEAwwJbG9jYWxob3N0MCAXDTIxMDUxMDE0MjEwNFoYDzIxMjEwNDE2
      MTQyMTA0WjAhMQswCQYDVQQGEwJVUzESMBAGA1UEAwwJbG9jYWxob3N0MIGfMA0G
      CSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8VJ+Gv2BRZajCUJ8LxGCGopO6w27xvwLu
      U0ztdJibWCUUYxGk7IDnhnarbpD18CnZ0bqqUvugn1Lod5rHUuDdh2KdMefiugR
      bu1jtKxi25kKfd+12nqph7dI9iuenroHUi5SBxCCKEQSo5282QIeltTtBASNiKB
      CBjdIu0wjwIDAQABMA0GCSqGSIb3DQEBCwUAA4GBAGm7Lrhd7ZP91d7ezBLQZ3L
      xciCZUmm6DcMfGgel13aI8keYID5LPUoIJ8X3uoOu2SV7r4G53mJKtyyqUKfbMBG
      DSq4rm8g2L9r5LdVYQFcvJjJxHGLMOvZUvm7NiQH1zd73nHYhu+0yravaUkywEl
      fhs+mOABareCK+xi+YT0
      -----END CERTIFICATE-----
    EOS
    (testpath"test.key").write <<~EOS
      -----BEGIN PRIVATE KEY-----
      MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALxUn4aYFFlqMJQ
      nwvEYIaik7rDbvGAu5TTO10mJtYJRRjEaTsgOeGdqtukPXwKdnRuqpS+7+CfUuh
      3msdS4N2HYp0x5+K6BFu7WO0rGLbmQp937XaeqmHt0j2K56eugdSLlIHEIIoRBKj
      nbzZAh6W1O0EBI2IoEIGN0i7TCPAgMBAAECgYBRusO0PW82Q9DV6xjqiWF+bCWC
      QnfuL3+9H6dd0WC84abNzySEFyLl1wO+5+++22e+IHdKnVKlTKLFZMzaXU88UJjG
      WwQdKhLPw4MvVsPNwFtDlP+EyKfzKHlQ5PAhPjw5Hz1isE2b98JNqMbj0QMZqpES
      hm391fmfk8QPBPsLyQJBAPpWUOfJcQUC1bh0qFXatLmg6A4DEHyhbZqkehcvZK
      zes71uzcW1NuzDE3ahbv3IFy5UOWWWiPXD1DpiGBYUCQQDAlzs+rd9Uaqq4ZfdA
      iH2wkUub+2kcRi59MlH9B22Wb+VmWTqcwwhVFlKB8to0bIsK+cae8D1VBYLhuZu
      yKADAkEAzxrYBlrOiPHGdLr2jYvUYnpvYSBB5In8znjMsmrXz3jTRNZFoNqCHT
      BqisuVspl2LBr7UKjodLrjXSUrrQJAUIuvQnKTcYm+5qn2c23iK0NIO5zsliD
      vuaZtZoysfUQWvK8ea1zwao5TZHUx1YbDzA5UjEprTDCm4WKwBB2IwJBANbtLRvS
      CsWbp+cEK+zSllqBhvlJQUf2DNQRGHsItbq1dbqNA3xF1WWh6IQSevN4M1exdBLa
      OOqlfB3Fyb6Mld0=
      -----END PRIVATE KEY-----
    EOS

    http_server_port = free_port
    fork do
      server = TCPServer.new(http_server_port)
      loop do
        socket = server.accept
        socket.write "HTTP1.1 200 OK\r\n" \
                     "Content-Type: textplain; charset=utf-8\r\n" \
                     "Content-Length: 0\r\n" \
                     "\r\n"
        socket.close
      end
    end

    trojan_go_server_port = free_port
    (testpath"server.yaml").write <<~EOS
      run-type:     server
      local-addr:   127.0.0.1
      local-port:   #{trojan_go_server_port}
      remote-addr:  127.0.0.1
      remote-port:  #{http_server_port}
      password:
        - test
      ssl:
        cert:       #{testpath}test.crt
        key:        #{testpath}test.key
    EOS
    server = fork { exec bin"trojan-go", "-config", testpath"server.yaml" }

    trojan_go_client_port = free_port
    (testpath"client.yaml").write <<~EOS
      run-type:     client
      local-addr:   127.0.0.1
      local-port:   #{trojan_go_client_port}
      remote-addr:  127.0.0.1
      remote-port:  #{trojan_go_server_port}
      password:
        - test
      ssl:
        verify:     false
        sni:        localhost
    EOS
    client = fork { exec bin"trojan-go", "-config", testpath"client.yaml" }

    sleep 3
    begin
      output = shell_output("curl --socks5 127.0.0.1:#{trojan_go_client_port} example.com")
      assert_match "<title>Example Domain<title>", output
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end