class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.541.tar.gz"
  sha256 "5732ac69a679a4ce2b15dac5a137af332fd482cd9dada6b3d5b10059db69ee18"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c6513f1f1757ad3cdc51fc547c48f2e818c847a7d3a34a104e6ffa51f09d17eb"
    sha256 cellar: :any,                 arm64_monterey: "8553c98d1f8d79cfe04f113d0e43e181045d58c28f9f41d30d5ade109850d4c4"
    sha256 cellar: :any,                 arm64_big_sur:  "9abb0692d37bbbccb4ac22a917e74fc634af9aaf808678fe899eefdac4cddaf1"
    sha256 cellar: :any,                 ventura:        "b2f0792fae40ce1367a13df346aca18bf5ff65a5b6cee259b501b44cecefb2c9"
    sha256 cellar: :any,                 monterey:       "93d90a4f2380d45a02db786513d76a2f00df30bf16ce0bb942cdccbff216a5f0"
    sha256 cellar: :any,                 big_sur:        "d698c7c039fcef669b3dc2effe6dd268833f7e6241d9e78c56c6b01b90d28b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "231bd4026b79a7f11b42799a4d1a435125c999d9efd33187af216deddca13b7b"
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