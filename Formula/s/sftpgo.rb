class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTPS, FTPS and WebDAV support"
  homepage "https:github.comdrakkansftpgo"
  url "https:github.comdrakkansftpgoreleasesdownloadv2.6.1sftpgo_v2.6.1_src_with_deps.tar.xz"
  sha256 "4e325a752d43233af1f50245de3cf59dae89d1efbb561629da1af131a4d8c5a8"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_sonoma:   "b7c582c2540be08906551e4cffcdd80e89dd2aef5a55da1c4764a289dade986b"
    sha256 arm64_ventura:  "e5608be6e54fa44846fcdfa6deaa9d3a94f7e8277c78fa6106909232acaaa15c"
    sha256 arm64_monterey: "45d0bfcef50abfe7a445a41bbe3d4efa4642737e55b2cc2314835280f94962dc"
    sha256 sonoma:         "84b0c3a7c896b03f14a186ac7582b1191e45ee8004ddd28978ad22b4ef239ac2"
    sha256 ventura:        "5bb7aca9998c63fb67e2a3db8e2d6617e28dff9b595b93db99366087a8a064d8"
    sha256 monterey:       "cc3f401788f60c9e85dcb48668957946814b07f8a7d5c7f580fafd7c4a77e1e0"
    sha256 x86_64_linux:   "0a53d5a008d7a4d37f9f923da2d5534bdea46c85394698977523f7bbb86ea169"
  end

  depends_on "go" => :build

  def install
    git_sha = (buildpath"VERSION.txt").read.lines.second.strip
    ldflags = %W[
      -s -w
      -X github.comdrakkansftpgov2internalutil.additionalSharedDataSearchPath=#{opt_pkgshare}
      -X github.comdrakkansftpgov2internalversion.commit=#{git_sha}
      -X github.comdrakkansftpgov2internalversion.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:), "-tags", "nopgxregisterdefaulttypes"
    system bin"sftpgo", "gen", "man", "-d", man1

    generate_completions_from_executable(bin"sftpgo", "gen", "completion")

    inreplace "sftpgo.json" do |s|
      s.gsub! "\"users_base_dir\": \"\"", "\"users_base_dir\": \"#{var}sftpgodata\""
    end

    pkgetc.install "sftpgo.json"
    pkgshare.install "static", "templates", "openapi"
    (var"sftpgo").mkpath
    (var"sftpgoenv.d").mkpath
  end

  def caveats
    <<~EOS
      Default data location:

      #{var}sftpgo

      Configuration file location:

      #{pkgetc}sftpgo.json
    EOS
  end

  service do
    run [opt_bin"sftpgo", "serve", "--config-file", etc"sftpgosftpgo.json", "--log-file-path",
         var"sftpgologsftpgo.log"]
    keep_alive true
    require_root true
    working_dir var"sftpgo"
  end

  test do
    expected_output = "ok"
    http_port = free_port
    sftp_port = free_port
    ENV["SFTPGO_HTTPD__BINDINGS__0__PORT"] = http_port.to_s
    ENV["SFTPGO_HTTPD__BINDINGS__0__ADDRESS"] = "127.0.0.1"
    ENV["SFTPGO_SFTPD__BINDINGS__0__PORT"] = sftp_port.to_s
    ENV["SFTPGO_SFTPD__BINDINGS__0__ADDRESS"] = "127.0.0.1"
    ENV["SFTPGO_SFTPD__HOST_KEYS"] = "#{testpath}id_ecdsa,#{testpath}id_ed25519"
    ENV["SFTPGO_LOG_FILE_PATH"] = ""
    pid = fork do
      exec bin"sftpgo", "serve", "--config-file", "#{pkgetc}sftpgo.json"
    end

    sleep 5
    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{http_port}healthz")
    system "ssh-keyscan", "-p", sftp_port.to_s, "127.0.0.1"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end