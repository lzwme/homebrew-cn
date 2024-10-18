class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.809.tar.gz"
  sha256 "e4a8e10b757ec779d876d33abbe2c9501fef7357d4ac49fdb3dbef8a4e475bec"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb6711017ca7cc954ef91b75824180714affbaa654966b6397bbfb425019e2e6"
    sha256 cellar: :any,                 arm64_sonoma:  "1ea1e3c6dc606391eeff286dc379978d6111d5f2b6790cdc110f75d370b8113b"
    sha256 cellar: :any,                 arm64_ventura: "496988af088cb157205c46a4434a62ce4686c29b3169098912680a463a0e676a"
    sha256 cellar: :any,                 sonoma:        "9c4fface0a564d8dbab769737b9e735c69453c6d306efae25e78739372fd2a3e"
    sha256 cellar: :any,                 ventura:       "b131505888223f84bb0b968a41c83b13bb892e1e05260f8c55723a02e1e0c4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a67a8e0ac0cf30e000c810024e8b04c9251cb3f2b1f00baf1ef4a3d82f61f7dc"
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