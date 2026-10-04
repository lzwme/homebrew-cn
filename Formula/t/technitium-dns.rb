class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://ghfast.top/https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v15.6.0.tar.gz"
  sha256 "cfe796e9f9c9ded70cc8002a90d68d9663f20765062c385d24e4e5ff1b13ddcd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "363b4f77fd519c3d7e8aa6fc3f3d42a8e092cf4eeafdd622d8149e9527a6e34b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e37d485d0d8175f916eadedc3729b808386949d49a7602ca90a1692c29825de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae050b9360a01b162481a425f5825d3f82ffee52141dda96e28ea98350455dc6"
    sha256 cellar: :any,                 arm64_linux:       "7388a2d59e5c9a52b8eb67e75ead5b43d7562caf4ab3508c5d24d477966c72e7"
    sha256 cellar: :any,                 x86_64_linux:      "75cbd99442397725874e17cc4351b9ed0dbe14275cedbad5b0893bc4de31562a"
  end

  depends_on "dotnet"
  depends_on "libmsquic"
  depends_on "technitium-library"

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    inreplace Dir.glob("**/*.csproj"),
              "..\\..\\TechnitiumLibrary\\bin",
              Formula["technitium-library"].libexec.to_s.tr("/", "\\"),
              audit_result: false
    system "dotnet", "publish", "DnsServerApp/DnsServerApp.csproj", *args

    (bin/"technitium-dns").write <<~SHELL
      #!/bin/bash
      export DYLD_FALLBACK_LIBRARY_PATH=#{formula_opt_lib("libmsquic")}
      export DOTNET_ROOT=#{dotnet.opt_libexec}
      exec #{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{etc}/technitium-dns "$@"
    SHELL
  end

  service do
    run [opt_bin/"technitium-dns", "--stop-if-bind-fails"]
    keep_alive true
    error_log_path var/"log/technitium-dns.log"
    log_path var/"log/technitium-dns.log"
    working_dir var
    environment_variables DNS_SERVER_LOG_FOLDER_PATH: var/"log"
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    dotnet = Formula["dotnet"]
    # Start the DNS server
    require "pty"
    dns_cmd = "#{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{testpath}"
    PTY.spawn({ "DNS_SERVER_LOG_FOLDER_PATH" => testpath }, dns_cmd) do |r, _w, pid|
      # Give the server time to start
      sleep 2
      # Use `dig` to resolve "localhost"
      assert_match "was started successfully", r.gets
      output = shell_output("dig @127.0.0.1 localhost +tcp 2>&1")
      assert_match "ANSWER SECTION", output
      assert_match "localhost.", output
    ensure
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end