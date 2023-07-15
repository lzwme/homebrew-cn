class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.473.tar.gz"
  sha256 "bccb3fb477dd7442b2203010491af30a0c8bcb195744163a00a1f90b7d7fd992"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b70d8c27118b02bb4f547ce30c362ca51f6a8124075ba5bccaa856e11d4be095"
    sha256 cellar: :any,                 arm64_monterey: "307fa63e543478e8400b223a41f3b3693477965f39b2997caca5a3f0b2c0325c"
    sha256 cellar: :any,                 arm64_big_sur:  "71a925db57a006f1cafd17a010ad387d594d44e282e4714bc3b4384940437d84"
    sha256 cellar: :any,                 ventura:        "6a9222b94ba8436232cf722a6940cac131b532563642d7645c87dd0d7a4671ea"
    sha256 cellar: :any,                 monterey:       "e4d3fed23adfaeda44df8379afaf0afc10da887638ec7b718107799a940a843c"
    sha256 cellar: :any,                 big_sur:        "fedb1fccbae02890bda1d858349b4f438a6d60bd0457395592c19478cffcadcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0597103162a0baa98a396ee4401ccfdb49a3b763aa297a92164560ee11ebea33"
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