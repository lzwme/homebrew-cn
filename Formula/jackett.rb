class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4105.tar.gz"
  sha256 "1ef7407b680ef8fe54440f08696686aa276d5ca18e89b1f2dc7ce6bc3ce33c29"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "120d3f21e91d76e9eda5712d721db51d433236e484db0eb1b9ed46b54e693f18"
    sha256 cellar: :any,                 arm64_monterey: "11ae8834380679792058cf8ae0af315fd7526b36634e55486be94666927b8d85"
    sha256 cellar: :any,                 arm64_big_sur:  "5fbdacfdd8f1fc966062c64002d3483d9ebef60e3f556c94db7d7ef7754e3a53"
    sha256 cellar: :any,                 ventura:        "c6347b232173f0df2b100d48e9130fec6244505fdf213a038fac7bc8687d0f88"
    sha256 cellar: :any,                 monterey:       "947cf6cbf277960d55c3f9ed313c776da498e7a59a2dff0cbe4c45ba34f043aa"
    sha256 cellar: :any,                 big_sur:        "3b627938869ddc453dbd6050fe178528121dd93b64be2c98e2eabcfbbf8f97d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b3286e485ec435aaa72c80a3d6d38cec6d3b30680a8577df659d9a56fea021e"
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