class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://ghfast.top/https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v14.3.0.tar.gz"
  sha256 "5f71c0661d22a5dd75374a9888bbd67469d1ba0b6b9947df770ec4833b7f36c3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44a0aacc0e40a4ded693196af29585b824d50a89eab604596e6baf39d75b618b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d839fe04ce2f5a1353c3f383e38770b05aeeb2da69aceabd8d64522c5257587e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e9f620d973dbe55836c79c2e4b2f45bde4a6ee01fea3eab47bf1087695d3ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "231953d405e500b13bfdebd0feae8e0be0bf8df6487122b5629c0a057e87229b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75da168d8b3f17970b6c90ffd0853cbc5a704bdfeff6a9240a3e398c53ddf94d"
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