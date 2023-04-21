class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3949.tar.gz"
  sha256 "051401c896835086ef7eead477723060c243ba90f82d622d96bb6ae269bfaa6d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "79b4e32a515abfa7c2b08e4affe322e097cba745a1e3f87f0018e1cb14ff6809"
    sha256 cellar: :any,                 arm64_monterey: "49b9676d8e2fc4f8b82a60fc87ebd206c92e0abb19826a76ec643dec23e846a3"
    sha256 cellar: :any,                 arm64_big_sur:  "9225e5638cae0e97783cd5438269cbca42f58f058673d1b4a2dde3c294452edc"
    sha256 cellar: :any,                 ventura:        "a2f8ae82c118931b0b8a917423a15c0041db097dd005e3dcd8acebef84a37b0e"
    sha256 cellar: :any,                 monterey:       "3ef7906ab8f66bb75d1fde6200955411500f6e81e63d166e07aae7e8817514c2"
    sha256 cellar: :any,                 big_sur:        "161e7cc3ba177beb31964d4a0f10adc91a4bd2795325f8a75b1f34e76990a359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e05aa9e77a4457c4c5c7a52e3c1de41af994edb126468b1f4e525557bdd5792c"
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