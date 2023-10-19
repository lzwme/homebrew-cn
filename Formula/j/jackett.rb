class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1043.tar.gz"
  sha256 "f729ec6f97b276be3dd56c92bd6312026ca339c3decfb2ad1c2c26c8f0539cc9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "190ae50bfb7ff6c5847fee7e964a3adc8eaffa1f5bedd0c2b4fa54273c5850ba"
    sha256 cellar: :any,                 arm64_monterey: "71554347f17106cf28de4f7ea5400849f124a551a199b59edbed7075d717af4f"
    sha256 cellar: :any,                 ventura:        "97d385cf467d0b2ed2e0a8feb67da3f3cc6832b6fea69b0f2dd8e4754d6ce35f"
    sha256 cellar: :any,                 monterey:       "99ab98a30cdf6545d65a58edd9e66737cd9e090abfc204856f43a1b2e38332b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "425ed2de1c6bf2557cdb7d2e475d31404565b5d92c51619b12154574a66a8160"
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