class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://ghproxy.com/https://github.com/drakkan/sftpgo/releases/download/v2.5.5/sftpgo_v2.5.5_src_with_deps.tar.xz"
  sha256 "886da134f01ef68b2c22e9fc90e437eaf5b4829b5f550a0f1adaa6e9be93432e"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_sonoma:   "75318a239cd51aa34aca387f53008c69d5842fb1e0c82d40171701144ef13fe0"
    sha256 arm64_ventura:  "012e0c2903a8916420bda1fce768b080276ea23e6c86d1ec9e1a2b7034bd207d"
    sha256 arm64_monterey: "027a2c4193eaab20580cb2b68d600e0ce7a2b87f72d5ba091002f6cc153389c2"
    sha256 sonoma:         "4315b39ce53babf3b7fc11d6c6f87e1c45acfcd08b5d9a8000e76014b49a59ce"
    sha256 ventura:        "a6f72464eab21e90ca29f450dfb7611877ea675a6d546f61054cf2c7b1c36bbf"
    sha256 monterey:       "9c75255eae26643627eb7fa83d49acfd3065c82c74d24ecb9b5197fce5ed9de0"
    sha256 x86_64_linux:   "a49eb78c9f435e6f98c086da3244edc43643b43278131b93e684d06347f5f0ee"
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