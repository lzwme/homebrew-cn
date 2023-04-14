class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3897.tar.gz"
  sha256 "470fb842d2a53ff8088ceee1a4c8379d157517a922c71d3a2a2aae8dbad693e6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f40317f573a1b55c2fa28758410e81be3796e7bc7f747df1d37e38c72562b3c6"
    sha256 cellar: :any,                 arm64_monterey: "02d9bc460310e5aef03ee09580c5153220bb05cf6f1e16944e09c1c2938b9c68"
    sha256 cellar: :any,                 arm64_big_sur:  "1b961b6b4bd193360dd3349eef675f5ede12135e3aee08cf5a11f660b42c7e09"
    sha256 cellar: :any,                 ventura:        "17246a203e19d32c5d9dc35148e68a51754f1c01c677325a975cb65a4b8d80d3"
    sha256 cellar: :any,                 monterey:       "92915c1df7389c6dfdc42a1a6a894fa439f616f22688411d59e3a57da036f3b9"
    sha256 cellar: :any,                 big_sur:        "8cac9ebdb5d7341cc58f7aac34ba8b41377804a2d30691cc97dda9f428d69933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8301d89581ea9e46bad014211f07631ae3ff1cc587cd89ee27f1293f34114c63"
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