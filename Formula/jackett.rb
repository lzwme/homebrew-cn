class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.497.tar.gz"
  sha256 "c635d00b62598a36216b0d83dc135250783112468c75f5803e9f6a9d3c21a8a3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f736e8d0a14f6df3b99563901036c801fbea53f3ce67fcd90ae77d23d93c8da"
    sha256 cellar: :any,                 arm64_monterey: "632100d3b7be9eb64ce10c70248e0e7f073489151a5097bdcaa4c7fa83e8c8df"
    sha256 cellar: :any,                 arm64_big_sur:  "e18e40a8a731b497f35eb98e62a3c2e87e46ec898c6602d15a8dc65f2d54faa4"
    sha256 cellar: :any,                 ventura:        "45d794e1c6aa651789753090da18e0f55cd9b17af29a811770a5b6add63a4b80"
    sha256 cellar: :any,                 monterey:       "3364eb2957cec0449f18c8cdb2fb356aa9a72fecd200771836be7c2e37c80aa9"
    sha256 cellar: :any,                 big_sur:        "22c002c374a95905231f0e184a54d0585b2b5560ad7cdde7259759482ab613bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5668a97a419e94de01d73a89f0a45e0ab228debbe51b13bd81da8f06929c638f"
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