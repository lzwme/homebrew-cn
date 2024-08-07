class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.411.tar.gz"
  sha256 "e076e9b39100bdf6e6993e4b1791ef980b472517143b89e6a4713574200bae1e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc0782191e8b08862709e4d8008d7616486813c642b8bce8db984af966556684"
    sha256 cellar: :any,                 arm64_ventura:  "cc313a8c5e605f46fbc2f588fb67bb45f19faaa69fcb86f6dddfdc44ed80915d"
    sha256 cellar: :any,                 arm64_monterey: "daa65a3fc4d9b76cfb8f577e87c91c9a667e7acfeeb02f412ba2fd111a6e99bf"
    sha256 cellar: :any,                 sonoma:         "5f6bf4663da78e4e2d6c20e186411e6959e57d619776f1a00e74a365319afd08"
    sha256 cellar: :any,                 ventura:        "1dc7bb2102b90629b9a8ff1e4c8833a4b3ab84f92c6b5636198493b887264cc6"
    sha256 cellar: :any,                 monterey:       "7988e6e15a002ae7f74cf555829d312867b8893d25957ad1720e795fa21cf975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfb1d67ff4257d93c94097a25e31e268437042cec853826a033d3f3b82f3cdc3"
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