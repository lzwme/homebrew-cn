class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4125.tar.gz"
  sha256 "3b48c9e59361956736e5e28840fe41cb1fb637d15b6cca5526a06d80193ccf24"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "33f3e8f46cdc9999295ef7e77c7eabc6b18f9757b8608f9f9a718561345162e5"
    sha256 cellar: :any,                 arm64_monterey: "9d867c5de5de3fe5f10aedb7ba610e9151ea40389f3ff1bde8c8480295a4b1b0"
    sha256 cellar: :any,                 arm64_big_sur:  "e1678b7294b2a3bfab6d970e279cdc502f330a290e766f751e681054b7d0672f"
    sha256 cellar: :any,                 ventura:        "cb405ad4bfdd078e225c098868458505606f44caa95f09c5308388b7edaa77b4"
    sha256 cellar: :any,                 monterey:       "0f3c44e9c1d39e181860c74b45b043f55aa225238a48f765096c49bc4bbaaf81"
    sha256 cellar: :any,                 big_sur:        "e5b53a6609323746fb0d74bebf0067411f67f8cb2522642494fe2692b4673013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1741aa878ec283f4bbda6a0646ce94021224ddb2d84248964b62318f0a368c4d"
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