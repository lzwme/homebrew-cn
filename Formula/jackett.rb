class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.352.tar.gz"
  sha256 "7f6feb04650302925fb203772dd4e8335c3083dec0b01feabd84d998d25d761c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c7c1b4728cf91bd06cd888747d448671ee2cbf90c88d42ed8f57f81ec594f05"
    sha256 cellar: :any,                 arm64_monterey: "d3f55124b5b0fa8c608d1f73b5ece7654afdae5158f2d158bb1a1373e770d100"
    sha256 cellar: :any,                 arm64_big_sur:  "8e0ca4ad075675f8326fdb15cc3a8660cdd21b794828feccca0b427a41bfebec"
    sha256 cellar: :any,                 ventura:        "c8b177dfbbf362c9f9b8842b4bcfa4a5a651825a073162b585cf393de2c22d4e"
    sha256 cellar: :any,                 monterey:       "991a3c391236fd3def65faffccd72c13f7a1d14310d1a7051206627d0f0f0233"
    sha256 cellar: :any,                 big_sur:        "94c16d3497393bfd715c23919c7e7fc2bdcd5bbe9096ef48a061dbfaa209b2e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f79e82fdb284edf40d742e3c8dcebe416497ec59152c3b4a0b1b491a73e171"
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