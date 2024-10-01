class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.694.tar.gz"
  sha256 "e0fb13d4cf7ce59402ae757c908617a3c80b7646a5f0046434d34eb6e3e28945"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e495d4222bf9dcba93bacc67b80504cfeeb6fcf72eb9dde392583e164239c81"
    sha256 cellar: :any,                 arm64_sonoma:  "99e99cafe696e0073084f39a3408a8cb254ea1c630dd4b929dfdf17fec1b82dc"
    sha256 cellar: :any,                 arm64_ventura: "bc9d193cbfc81252afec11342dadacb8128e82929469f2ef353af1ab8688b784"
    sha256 cellar: :any,                 sonoma:        "2e0aaaf004d1ab68a43a6bcf65ec08bf7a1f375a4997eb1ad29ca3da8a9cb3d4"
    sha256 cellar: :any,                 ventura:       "3830d930fb9ca9a5a2b072262a3e594378e19294c761cec1757716618dbbc352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74534ba50512e3de8695f9635139c9c84942d0a32f8683ddb9c2e6dbb2c7d88e"
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