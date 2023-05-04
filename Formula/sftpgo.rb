class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://ghproxy.com/https://github.com/drakkan/sftpgo/releases/download/v2.5.0/sftpgo_v2.5.0_src_with_deps.tar.xz"
  sha256 "da48a0c3cd1b800cf35dafe39f4fa12a0cc1da0dfe297e1a5b4730a57477f7ae"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_ventura:  "300b85138e11f76e01c38bc070018f735f5bda34d482d305304336bf2f3a3bd5"
    sha256 arm64_monterey: "5d8a28764b0f0650dd252d7d45d07929a8a7af23c112fddc66ed4da043c0eabc"
    sha256 arm64_big_sur:  "a9f61b3ea73acb94464f5db890a5fbab07532e97ea19166d9e3cdd02549bac2a"
    sha256 ventura:        "8ab60bf29c240c1b83f2a65cae12a66e379fb619ac02520b64a874da41baaafc"
    sha256 monterey:       "479f34e466d678027a29e603487d8c5895a5b1325af734c1a140cb3d5afb49d4"
    sha256 big_sur:        "da2ab9c005d6c6e9dde27a2091b15f250f33c9b43e6a3f055fa00e0b11112379"
    sha256 x86_64_linux:   "d23771e475bae80d01f34c0aa26a967c6e319a21d5aac4c2c8b5fabbab092509"
  end

  depends_on "go" => :build

  def install
    git_sha = (buildpath/"VERSION.txt").read.lines.second.strip
    ldflags = %W[
      -s -w
      -X github.com/drakkan/sftpgo/v2/internal/util.additionalSharedDataSearchPath=#{opt_pkgshare}
      -X github.com/drakkan/sftpgo/v2/internal/version.commit=#{git_sha}
      -X github.com/drakkan/sftpgo/v2/internal/version.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "nopgxregisterdefaulttypes"
    system bin/"sftpgo", "gen", "man", "-d", man1

    generate_completions_from_executable(bin/"sftpgo", "gen", "completion")

    inreplace "sftpgo.json" do |s|
      s.gsub! "\"users_base_dir\": \"\"", "\"users_base_dir\": \"#{var}/sftpgo/data\""
    end

    pkgetc.install "sftpgo.json"
    pkgshare.install "static", "templates", "openapi"
    (var/"sftpgo").mkpath
    (var/"sftpgo/env.d").mkpath
  end

  def caveats
    <<~EOS
      Default data location:

      #{var}/sftpgo

      Configuration file location:

      #{pkgetc}/sftpgo.json
    EOS
  end

  service do
    run [opt_bin/"sftpgo", "serve", "--config-file", etc/"sftpgo/sftpgo.json", "--log-file-path",
         var/"sftpgo/log/sftpgo.log"]
    keep_alive true
    require_root true
    working_dir var/"sftpgo"
  end

  test do
    expected_output = "ok"
    http_port = free_port
    sftp_port = free_port
    ENV["SFTPGO_HTTPD__BINDINGS__0__PORT"] = http_port.to_s
    ENV["SFTPGO_HTTPD__BINDINGS__0__ADDRESS"] = "127.0.0.1"
    ENV["SFTPGO_SFTPD__BINDINGS__0__PORT"] = sftp_port.to_s
    ENV["SFTPGO_SFTPD__BINDINGS__0__ADDRESS"] = "127.0.0.1"
    ENV["SFTPGO_SFTPD__HOST_KEYS"] = "#{testpath}/id_ecdsa,#{testpath}/id_ed25519"
    ENV["SFTPGO_LOG_FILE_PATH"] = ""
    pid = fork do
      exec bin/"sftpgo", "serve", "--config-file", "#{pkgetc}/sftpgo.json"
    end

    sleep 5
    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{http_port}/healthz")
    system "ssh-keyscan", "-p", sftp_port.to_s, "127.0.0.1"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end