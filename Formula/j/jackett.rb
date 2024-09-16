class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.604.tar.gz"
  sha256 "6e6632967003b39b667fae301ad967a4c6651308246f5a0a6db99c42cb549a36"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "62f75e06aca2981d2252896094fae4c89f2c691f00c54e73f04636ba14d6ae1e"
    sha256 cellar: :any,                 arm64_ventura: "0ed1d84b9fce7977bb8c7cf35555454a165085e74fd15f26f4a4fdc8dbcd9d40"
    sha256 cellar: :any,                 sonoma:        "be15e1447e664ef3479ca55cdf268cf042653b95e46b381b984087c473b83a6a"
    sha256 cellar: :any,                 ventura:       "bcf6c6291551744b21bef7b18df3930f404a5cbc9b635ed11484c051e67adf55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa5ce01cf45b299e1ec0729b2c0b1af3e588f272e4c779d5a5d58c98b53d4a0"
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