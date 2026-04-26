class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://ghfast.top/https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "f2f7cc829699adacfe3fbf2dff735e02656c6f7ac1076fa4e07c90db62ca21eb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85db9fdd25a5ccbd276d7f0e8ff1f0e2fd8a7461a547879069c7480bb64d8f91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01cb904ff840565d0dcbc8099a3789e3cfdf169046a378e9442f20a9b5bfcafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28c12b3dcacf89dd3e3d4f5801a46efe7b57de8cb31c3294d94ff65f44cbcb8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7757dadbf70ae8ed61f800f6a3cba694fd83e5b640109a5897e42a141dbaad0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7293f1379eab109babfb6d8c23ab458f4fbe30e1df00a2ad41b070ee4bbfd3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c5e9e569ce9f4963b5eb011651a4763c928748a24f07b47461e5e710f9bd8dc"
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
    environment_variables DNS_SERVER_LOG_FOLDER_PATH: var/"log"
  end

  test do
    dotnet = Formula["dotnet"]
    tmpdir = Pathname.new(Dir.mktmpdir)
    # Start the DNS server
    require "pty"
    dns_cmd = "#{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{tmpdir}"
    PTY.spawn({ "DNS_SERVER_LOG_FOLDER_PATH" => tmpdir }, dns_cmd) do |r, _w, pid|
      # Give the server time to start
      sleep 2
      # Use `dig` to resolve "localhost"
      assert_match "Server was started successfully", r.gets
      output = shell_output("dig @127.0.0.1 localhost +tcp 2>&1")
      assert_match "ANSWER SECTION", output
      assert_match "localhost.", output
    ensure
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end