class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://ghproxy.com/https://github.com/drakkan/sftpgo/releases/download/v2.5.2/sftpgo_v2.5.2_src_with_deps.tar.xz"
  sha256 "b99244d3d46028c16677411455eb1df43f7781aad1edbb7df211a569821b5890"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_ventura:  "458d47128407aced380c783ba6d1a0b15923db1e40645d63ae15bcdd570c4b11"
    sha256 arm64_monterey: "a281b9b11faf9bc9d71fcb4e480ecf7b1769088cf5bf03a069a4f6684fa058f5"
    sha256 arm64_big_sur:  "3bdfa6928857b9c58dc55d1b326d719824448e22b98c5ba2e3bf0df9510a34c6"
    sha256 ventura:        "0be00ac0af632da64133d10c796f43dfe76dee5a5f511d0d62d35dd8c513491b"
    sha256 monterey:       "42e8be98faf0550c824dae1d3fc293e19626243731b8761ca8b2173abf3adf73"
    sha256 big_sur:        "d19cf112be10ce810fdedd1d00a9c2ec65583b0eb35a251450707ed3287a55de"
    sha256 x86_64_linux:   "ee1cbabfe160dd559d42080ca6f6fa5b67638892fbb40a943f4d70d3a8f00718"
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