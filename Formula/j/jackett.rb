class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.800.tar.gz"
  sha256 "7e3e0ec610a090665e712c38069822d4974e19ee3281558cb1accf461df48c52"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05599f1cf3e50b99798345a2daa0c7cbbc3e2fd9507ee1d373c0fce4dad0c688"
    sha256 cellar: :any,                 arm64_sonoma:  "770483e11c636d5e95ae094172505c103851429b173ce211d0e59944a3f87d0d"
    sha256 cellar: :any,                 arm64_ventura: "0ed18469fc021e095da2faa17084732a79643046a214c36157d56ab29a2ea5b9"
    sha256 cellar: :any,                 sonoma:        "7c726baa416ba0521849634cb8626dee7b4c8ff6a092b486474f9c7ec308f69a"
    sha256 cellar: :any,                 ventura:       "f14b42a9c34533aabfe32d068813fd905c679b9d047f8833d34454f236617dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5702f8b5793f9de05025ca5477a1a6a2af4757e700cbbff58797ef5df1348b23"
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