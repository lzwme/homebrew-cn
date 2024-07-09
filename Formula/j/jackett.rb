class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.301.tar.gz"
  sha256 "796a615168254a3a8c063d08761fc73b65f5a07e4845109cfee77f7ea5f5e950"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eddd72dbbc328b7f55a37db3436208a8ce21918faa9dc7fd0b9a5a1bc69531ac"
    sha256 cellar: :any,                 arm64_ventura:  "fa5e4a2485863d75d37dfc3015614744b8e2e32bad88815e1359f78eb642319e"
    sha256 cellar: :any,                 arm64_monterey: "54cc71bee333d1d038ef7626b36a13bca41caab6c512f78a5eb530d39b62cafc"
    sha256 cellar: :any,                 sonoma:         "79a5141864aa0d106a755733c1983008f454ee2c98def8dfca0528eb359e0413"
    sha256 cellar: :any,                 ventura:        "6cf6926968ff5e114168a405f2a5ff39ee5b0d2d31c3df33ae2f7d57db445ae0"
    sha256 cellar: :any,                 monterey:       "0837bdf689952c370d1549ffc26abcba2456996567d337f4e6c34f247ff97079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4334c7f2fc60f1adb8e3bd9932c963b5604e575af68aafa1447747c53d1f14df"
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
      exec "#{bin}jackett", "-d", testpath, "-p", port.to_s
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