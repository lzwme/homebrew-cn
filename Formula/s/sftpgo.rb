class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTPS, FTPS and WebDAV support"
  homepage "https:github.comdrakkansftpgo"
  url "https:github.comdrakkansftpgoreleasesdownloadv2.6.5sftpgo_v2.6.5_src_with_deps.tar.xz"
  sha256 "d59ff577b786db01bce358c74b99faf9170e53451d89200d9a51276b67ae1e29"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_sequoia: "dd8ffef87c5e1d736d739ffbdb258611272ccb887a470529931f6fcd8f24c624"
    sha256 arm64_sonoma:  "764b808d6d018cbb50d905e7cfa032d43e40bebe09ec9ed22117ca9dda5ab221"
    sha256 arm64_ventura: "e496193a0c5cbf89b8ed3e65495cac46fc73467d77f78d250cda86e3b7289e94"
    sha256 sonoma:        "b6cb2ff30c136936fbcb5639283fffd6c93ef1f1e19b18ead441b3a871751542"
    sha256 ventura:       "b5a8dcf5b622e0104d9ac313f6118db1f08d7594517ed89cd3a00b077bb30baa"
    sha256 x86_64_linux:  "bb4471bf1bb9a3a7927fd6c49e3b3e247638e69104d16be53dc2d3fcbcc04400"
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
    system "go", "build", *std_go_args(ldflags:), "-tags", "nopgxregisterdefaulttypes,disable_grpc_modules"
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