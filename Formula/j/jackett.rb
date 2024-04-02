class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2253.tar.gz"
  sha256 "14fd9a98f0707a90a181e31c72cb46b11bb8ff4ce1e5ed6db272006cd20244bd"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "42da439b1c426f54bdfb8aaec61d90433929a5b0b7da045e49e04c1f03312360"
    sha256 cellar: :any,                 arm64_monterey: "10c09e02282e045506f51ea94f64f157a384b5e7458ac29233662035ff54328f"
    sha256 cellar: :any,                 ventura:        "1a929b1c2c4526797fcb8118c6a34be80196b66de53d77c116f9eaaf77501433"
    sha256 cellar: :any,                 monterey:       "8dc3e6b27d1e39515b56c6a384464c993843a4bfda728b5b3d3addc69d2c5df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ad39190d65d629983e1387b12e599c7840f3b83a202399b5a4e319a9fdf70e"
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