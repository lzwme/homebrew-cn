class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://ghfast.top/https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "c21e1e2f74cec3fb6a7a2baa8fe031a4e023776dca646fcaa8e7748d5960ab8a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6633f2d60c4f06fda126a757adb972bcbe8ac273fc3f76bd36f80e47042443c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "835dc5a00290815d8085f46c8feab9dca6121d2642517ac4786aa542867d3bda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "798f50117baf091949b85c1ac68f5f8d9faa1f0293ffccd9a6638ae656d8eca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd932275d852f74ee5541f6ae6a34449628bf61920b812483ad6fa4ca5b3679c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c504abd6dff956be0b1130b65f9df9c1dcbad172aeb3211041a0197cb60e5fb"
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
      export DYLD_FALLBACK_LIBRARY_PATH=#{Formula["libmsquic"].opt_lib}
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
  end

  test do
    dotnet = Formula["dotnet"]
    tmpdir = Pathname.new(Dir.mktmpdir)
    # Start the DNS server
    require "pty"
    PTY.spawn("#{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{tmpdir}") do |r, _w, pid|
      # Give the server time to start
      sleep 2
      # Use `dig` to resolve "localhost"
      assert_match "Server was started successfully", r.gets
      output = shell_output("dig @127.0.0.1 localhost 2>&1")
      assert_match "ANSWER SECTION", output
      assert_match "localhost.", output
    ensure
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end