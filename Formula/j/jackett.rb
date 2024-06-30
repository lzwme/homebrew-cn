class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.228.tar.gz"
  sha256 "ebacd998b5f4b04f990dad68a75e72004526190448715016a9b8a3a3ed39a7d9"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cbf52438212c116e4a6992b46b2c0306dc67ba51df6deffe87e09e16241af7d9"
    sha256 cellar: :any,                 arm64_ventura:  "26ee1a3f02966419afc436457d770b7e6c6ed6be9313c36b97d28796613083a4"
    sha256 cellar: :any,                 arm64_monterey: "1b4dff5b3e0d2727b5f14c6636cab8f82ad403a509f56ff77e95b8839cd02f16"
    sha256 cellar: :any,                 sonoma:         "6eb245e9c5807ec955ed032934c7520c29cd0124072b689b5b36228b9e560785"
    sha256 cellar: :any,                 ventura:        "d2c7f55027cb2e206d8609bef8893d14f5f0031f8d66fefffae0bb602dc868da"
    sha256 cellar: :any,                 monterey:       "d2d1b9a12204a0722daa8800c1868d6ac61592a8c8367863c8442729da2a6809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fafdb6d0a25445c44cea849c21e28479ed5c8f595dcae5080342fc4b348972f"
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