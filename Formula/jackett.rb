class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3772.tar.gz"
  sha256 "63ecaeab3d0cac462ececf69b3bb892a4557d80292630fea43a019604199370f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9dfa64413703f7dade1c47284db485aa0961ad3c2bf7b2e3aaca30413a2621c9"
    sha256 cellar: :any,                 arm64_monterey: "87dc0c6404983ffbfb09ee8d5732d27f7c7cde4e780e764d6e4fc41f1db928be"
    sha256 cellar: :any,                 arm64_big_sur:  "81303fe17dd34f34d61e3050f29a5a27ac21c1855203af7ed2f487b79d5bac3e"
    sha256 cellar: :any,                 ventura:        "35b2012e72b4e6ea8995b78a20386bfa55fbdf8767dee6defbe6ddf3d7a8d4a4"
    sha256 cellar: :any,                 monterey:       "39cee6e0f363e0407d4d8d1f70c19c06e2fe371086d53ff739247f4aec255adb"
    sha256 cellar: :any,                 big_sur:        "e94572997c214ea957d5a4f3760871884ebdc7d81ebfc97457dc69f830667f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e6e30ce671deac310d27f30924b53da0797aa2a39356a66d0f575e126c2d5df"
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