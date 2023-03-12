class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3583.tar.gz"
  sha256 "92b2d5aee4b126593af93a78e78bd1daf3818be2775d697e331f0c39da199aa3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c980fd5849df5e1e90e67fff9d92889a9f4f12517e717ec3c5cb16bd310d694"
    sha256 cellar: :any,                 arm64_monterey: "0143c82dec3cce46d976fdab28d90887333dedbc9b4d6deec0748e00004ed97d"
    sha256 cellar: :any,                 arm64_big_sur:  "d4ed00c69d9057e26e894db64feb1e399886d999f5ef67a9d5533339b209825d"
    sha256 cellar: :any,                 ventura:        "c7cf4500ec7ead05d6ce08d24d3e55d864e5948c24ccc7f0891d2d3f2c2d2e95"
    sha256 cellar: :any,                 monterey:       "be0b612de0b5e47eb0e06bafbfb254d5e8ac59f09ba3dfdc6c83912e007c6373"
    sha256 cellar: :any,                 big_sur:        "0956e94d2f4cd79bded9f85e29fb6b72ddf0abc8cb31620ecd41053b3983eec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd9f1d6bdfdd268d09719b9b01e5ab86354f6e112eb140025d17f93be801df4"
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