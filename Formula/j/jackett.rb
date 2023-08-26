class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.695.tar.gz"
  sha256 "6bbe95d97bd84397f08347ec06031b746dd27346fe61053ef4ebb399d0ca5977"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d9fd9047427f76beae58fb0fe5af5f95f24b371a68577796d13895b41dec0b2"
    sha256 cellar: :any,                 arm64_monterey: "d67db20ce66f51322ffcf14aee31e58d91cf83a4162a4d1042ea896e204a3c92"
    sha256 cellar: :any,                 arm64_big_sur:  "810b286b62bf0aec58e394afaac93aca74114f68c6c8d0f8a244d23e76c636b4"
    sha256 cellar: :any,                 ventura:        "087487decb687492bd22ec77d61c6946aac72dea985e1eefa5fa4214d5c85599"
    sha256 cellar: :any,                 monterey:       "e15a7f8372faf0a03bf856c127cddb1b27b9bcf77d25c64e48c80a40b4749cce"
    sha256 cellar: :any,                 big_sur:        "3ad49fb44f497f24cc8908c802c5ea250c1bcc3527c87458a3cd9c209d484c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5364ed108ed1a9e37a91fb969289d597a339192a5ac09c27f45df0fbfb1642f"
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
    working_dir opt_libexec
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