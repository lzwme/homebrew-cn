class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2485.tar.gz"
  sha256 "d5e6d55640564accafeef6368c64b34ab2b63db0251d84b7c0bb629ce3a75671"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "71aae2263185bbaba559438dadbd1f5af45757ede85f903eb30c4a5edd2bee94"
    sha256 cellar: :any,                 arm64_monterey: "8dfc1bc47ff42e2abfe1939e91dc250036581b2b3245f8666158a06eaa1e22fe"
    sha256 cellar: :any,                 ventura:        "033e03ff7b3326001e9db61c955b34f0006d3f6aee79224b9582fc5562bbe82d"
    sha256 cellar: :any,                 monterey:       "502461d383c2c0694644343333ae2ab0c35016b03925acaecabd90b12e727338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a53a7ada5c7ebffb54f71e62ea75504bf0874f653d0be5a1814cd11f7e92d9a3"
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