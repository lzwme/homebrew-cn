class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1824.tar.gz"
  sha256 "64e8696a2371b412c8372d8379b40f98e36886a4ac1480e86dedb40f7f371d98"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "14aa209080fbb2997a73a5cbc5786a06a261eef6acbc85a0904b3aa968b9115c"
    sha256 cellar: :any,                 arm64_monterey: "86db83b56b6e9219281571a82e078eca4f8bca8ab031fafdb575dd3c76d68cc5"
    sha256 cellar: :any,                 ventura:        "7d0ec3091281dbe6b8ad7088af81dd1ca1ea8927ef12f23575d2b39b7a79b579"
    sha256 cellar: :any,                 monterey:       "0bf6212fc682832f014bc8c16a3f26110b316ebd258dbc10d3d8312f1bd4a02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d10338071ad28b76801817d03563be473fc72f698f781a21c5a6e9946bb940ce"
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