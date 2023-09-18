class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.812.tar.gz"
  sha256 "c28176f7551ef86dcec28de1dc668b568d5a967d79195c7eb58f51bdaa12cacb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "78ba85d834d24b368cb97b09ec61e3e8b91e5a2e79d3736b68acdfbc611317f7"
    sha256 cellar: :any,                 arm64_monterey: "49f82f8a937da0ec058cdeb107cd6dd7a48f7a4f0738229fdedf5a406d6cb99e"
    sha256 cellar: :any,                 arm64_big_sur:  "e8595bbd4d036d715e22c40095370d0cefbc43b9364fdfa5727497e550400d39"
    sha256 cellar: :any,                 ventura:        "fc9f0029d014c0c09938991be80826a3e00a510f4b14a2dc77055f89c0b8ae5e"
    sha256 cellar: :any,                 monterey:       "d57f5614a8baa5cc54f690967f8b4ac3ac5d5e3d1ee1a2420de6c90aa0ae738a"
    sha256 cellar: :any,                 big_sur:        "6d252597e815585a81e65420c3f725c7adf3269407e304124517b07e27b70ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c19cc6a3842c48d424e735a27828482feb3eceac8b86c308b0fbcc168b218ad"
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