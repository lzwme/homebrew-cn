class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.574.tar.gz"
  sha256 "12bdd25801a7a3267e41782e6690ba065c1b7df0177af18850b7deda2168d58e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7cdaacb3a6d702293f800c29d23e3f2673fe551f9244f1506c7790c223537076"
    sha256 cellar: :any,                 arm64_ventura:  "fe138e2c9bd53253d7f2152a0f07c292e14fe52c50c580000fc07538eb1b16f4"
    sha256 cellar: :any,                 arm64_monterey: "83dc61991af1a1793dd542b3bdaa8ad0b3b53a0944d42d4ef30a42f99a0323a2"
    sha256 cellar: :any,                 sonoma:         "8353649bb9b794527a0c47fdb75067b692c8e36bd9ff1cbdc3c9862536f63292"
    sha256 cellar: :any,                 ventura:        "e226072adbf9b91c95fcd5fcc7a6d147c319444f3d6a3be0c88a97900b110ab1"
    sha256 cellar: :any,                 monterey:       "6ae903fdb75dc618a49b23ee3b6729be347e4f4e6597df8f435ad43740e5d322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e25676a3c59e1f134cd82f7687b347ce7a3e313144429758b3ba429c44e2fb1"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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