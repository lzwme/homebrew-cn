class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.589.tar.gz"
  sha256 "36021b881f92a779ebf1f518ea15bd0b41251d950858d7f7d88137396b6411e7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f21064febdb3a0347f4fea3f4d96d2066ad21d1167f145f88b84e906c8f3d55d"
    sha256 cellar: :any,                 arm64_monterey: "eb4f407573230281a9720e8469328f86afa07ff8014211d912b2bb1275597cbd"
    sha256 cellar: :any,                 arm64_big_sur:  "50d1a7f66d545b0a41cc1545fe4ab2643f67266b53c43763ca15e25361b30df2"
    sha256 cellar: :any,                 ventura:        "49afe955c25c7c6f2bd32fb8d406fb2516ea641ee490d93f819f1c732157f7e7"
    sha256 cellar: :any,                 monterey:       "f49cc851f430fcbc8a937ba7388493fe23ee624deefd5dac01a3dc8e578d7e58"
    sha256 cellar: :any,                 big_sur:        "ff2dc53f6ee595355b076a87a10a09bc6a977ec8349c7f947cac6e2e39244ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4b4fb34b1fe27fd50755a4447804b874fd058fe6585a467e26517f6ad0efb7d"
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