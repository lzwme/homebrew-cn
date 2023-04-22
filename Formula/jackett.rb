class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3956.tar.gz"
  sha256 "a655fae741c1f48453e401d07cafa523324c29c3dba1da3b484ad61398d49e13"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6bbdc6df6440548e8250cc4046ea50b0cbdceb4080c057e2f0f38e81afc3520f"
    sha256 cellar: :any,                 arm64_monterey: "dd82f3e58c4a282067edaa5f3c3dd0f57b96d346ff53e442ff517eab1dc30ee0"
    sha256 cellar: :any,                 arm64_big_sur:  "18b4cb980066f3a08aadf627a03baa24db25631b0619918f34607bf116532806"
    sha256 cellar: :any,                 ventura:        "41da22a426ca1be5ab6809f074ff6d069087979028500ebdd5abcb9164e86dde"
    sha256 cellar: :any,                 monterey:       "f1135d744d8483f3ddf13c974baf8fcbcfbfbc7a9db1bdf157ff0ce33c4b1ead"
    sha256 cellar: :any,                 big_sur:        "91d2ac83cbec380d2d459f65240499f2929dd5b762d281c48bfcd0a532be49fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9dc50434342b63953239f06d40271a4cfb6831021c26c60fe52cb8eea3715f7"
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