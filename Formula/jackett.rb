class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3814.tar.gz"
  sha256 "950a28795af9200dea0dfe33de8ec414867083e3fed4c3e8dba771b832bcd7b5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d8a31b02fd3eb2bbf9a9a62ef9a483a492f3cf267ce76f59372057ae79e4159a"
    sha256 cellar: :any,                 arm64_monterey: "6a7a19b2221049b9b0def8ca68b039be58bce94c052d147024dcaf2df6b0a338"
    sha256 cellar: :any,                 arm64_big_sur:  "de58e3a6cdbaa193119e8892f61efaa3e8b10db636c3e67ea1511c62d88cc397"
    sha256 cellar: :any,                 ventura:        "bf8ca29b7119f4269c8f8cc31bb80b9f663f3500d64176f9b295e713ab8bba88"
    sha256 cellar: :any,                 monterey:       "944b5b4e0b7760effc1b5bda299682eb20e6ee96736d481f2ced744e8dd3c807"
    sha256 cellar: :any,                 big_sur:        "1d37f6139282ea53678da617cc13607a26824a276a5ad2f3d127a348d11c9ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f706ae0c467fae9ff439bc67e0ef05c683cfe40de51cd2a6d5b34f69dba0c7"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end