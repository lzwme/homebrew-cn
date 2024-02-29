class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1873.tar.gz"
  sha256 "90da7f6dfd92821bc7897488a27e07d22536b9f5873c3ae9da6d0ba76266e015"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5c8620912cacf0dccbe5dd576260dd886bdf846920012880f96cb991ad2f482"
    sha256 cellar: :any,                 arm64_monterey: "d8b3b3f057d0617f7a2707f668818bd1f0666513146a880d140e6cd944332491"
    sha256 cellar: :any,                 ventura:        "1fdd0ccce09b2e1daf0f37fc0ec802469b48b2695d4410b77a0b1e3ffcba3d97"
    sha256 cellar: :any,                 monterey:       "f7002ceeebd92ae21db0a21296a96ab7c02cf8b63850d2092369560f5943274f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1ffb5ad43da271b7f5ff1fbdbeea6291ec694c271ac6b6348a968e07673f7a7"
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
      sleep 10
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end