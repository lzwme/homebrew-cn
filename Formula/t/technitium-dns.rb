class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://ghfast.top/https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v15.6.1.tar.gz"
  sha256 "1e288eb4922066a6fb04aab92b1081ff1bb4384351b05413a9ca032134236491"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab81e811297317d900503f3ce24e438dd0a01bffdcb0f05907e4a3da18a1c50c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b23eaaf97de4ae815b45b58fb8bdbb1cdee376d69dce816f2b52a22d054ef4a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "962927e5dd9ae49d96ab935c11284a50950cc3d9d126d427b8fc867c6ec50d42"
    sha256 cellar: :any,                 arm64_linux:       "4b860ee34fe4541b9f3f07f59ca33c2a0eddb4c9ec2c232a4075dd659754485a"
    sha256 cellar: :any,                 x86_64_linux:      "866c264c4482b2209b6e6f29c1d099adb08cc183fd77eaab140f153dd4bee04d"
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