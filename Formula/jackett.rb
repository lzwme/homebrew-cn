class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.558.tar.gz"
  sha256 "deb9c2a94c581a163afea57ae7d2c5569052a614ade5c5f75951e14759dadbf2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aedb077f4ef196194dd28aaec489a877c007ca53e7f79d2ab9ccbb64d93c84f4"
    sha256 cellar: :any,                 arm64_monterey: "ed1c47733f46486fa65c490954251267a6a5bdfbb0082ec1b3cabbe7efe31fc2"
    sha256 cellar: :any,                 arm64_big_sur:  "aeaf792de112a28edb2a7d0472d44f91d2822c31490b947d3272d60549297e91"
    sha256 cellar: :any,                 ventura:        "701b616e1664adfe14d5e0f4e2821eb43ae61e513b206978b6137154cd33b3a8"
    sha256 cellar: :any,                 monterey:       "d5187ed007e572761ffdbfccb7a7153036e2c6b90365371eb81607b89af2d6fa"
    sha256 cellar: :any,                 big_sur:        "693454757ab2d7a80401d2919370f2eb35b7dd0ec2194d53491a146c45c2abc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e13c886c78e551d73e8bc42dd44e6e5da0edce194097ed61b7741988dd28b0c"
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