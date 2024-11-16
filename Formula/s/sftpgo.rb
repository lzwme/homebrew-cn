class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTPS, FTPS and WebDAV support"
  homepage "https:github.comdrakkansftpgo"
  url "https:github.comdrakkansftpgoreleasesdownloadv2.6.3sftpgo_v2.6.3_src_with_deps.tar.xz"
  sha256 "e7b68add57fcea56573dd6210c5f4ab53f112cc4394794230e967b617638e3e9"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_sequoia: "ac52ad6b956d905c7aeef06e7addbc926e0c70f1153cadb9e0b83dd005398559"
    sha256 arm64_sonoma:  "534cc1f8cfebba646c73f73a05349389df38ae82318b282f61f1bcdbc9b86ec7"
    sha256 arm64_ventura: "46a19b9a7daf5e736b860033a6dd8ea00b388799eb4361ea2ae72f80f4e5b7fa"
    sha256 sonoma:        "0df34fefd30dcc7f10dd1c8efe8ff1ab5cd15453419ed27b720d76f4db8584a9"
    sha256 ventura:       "03a5110cfad470f25ac6ab003138adf9bd248d4073d2ceeb726376cce1c91d87"
    sha256 x86_64_linux:  "abab91480542ab33cbbffcef6b844376b3e330bec2afd9f8ed5bea5aa7ac1052"
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