class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.860.tar.gz"
  sha256 "59603373757479e17a029ab65ffd25e9efafbb4b28457880673b23e609a8e2ad"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "377dbed68e949624d98c345553cf728478f8d9309d87b3b663b8204ca2f23eff"
    sha256 cellar: :any,                 arm64_sonoma:  "befcbda2b95e37018d90b425eac1e7265027761a11f56f0371852335a2800738"
    sha256 cellar: :any,                 arm64_ventura: "ff3b85f72aac74ee114f2bd911026a6313520af8177cd0f03a60aaeb2d18a608"
    sha256 cellar: :any,                 sonoma:        "2c8c0c04e88d9523bd5046eedd575d2987925929f7b214f3c3b5f61cf34e9c1d"
    sha256 cellar: :any,                 ventura:       "769c91da7aeda8237edc76139c4e6a5f3578aa40bb39b9ea80a56575d72a2304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a2311544d4546f188da43157ea56e3cdae2c80303c1e43de45d9177294ea7bf"
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