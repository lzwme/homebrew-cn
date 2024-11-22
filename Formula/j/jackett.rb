class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.991.tar.gz"
  sha256 "83a6208cd43266cf855770f44d4df84ef21b8fb316866c7412abf1c02b6fcab5"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7513cf6c05c25ab05e5bcdbcde4645890d1da1f7d9807a06fc682f5e96afbc24"
    sha256 cellar: :any,                 arm64_sonoma:  "7c65e99d19ce949c353fff17101decdf44c0e1572d6f80a6924dde796def5a26"
    sha256 cellar: :any,                 arm64_ventura: "71cf772c8538e384bf1b7b0f65f36fef37e46c7471ec96dd8424621c51e61a03"
    sha256 cellar: :any,                 ventura:       "96692be849567738db2f1129923344b55b0918e45d1a400e6459bddd4ef628d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dcf20e29137fe7b6cce6c74aacf03303bf0f898a02fe01243b956035e4fc15c"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end