class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.995.tar.gz"
  sha256 "4f73a8cd9f4286ae2f933f93f79041133da6e87f92a259ee03e726653ff70240"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a1f41d1f2434faca2ced3579334c9beca978f3a8dc63a5f76077ad9f9417660"
    sha256 cellar: :any,                 arm64_sonoma:  "4e990f0daff774648aadc23e19ebd42b023609e6581f6ee1a377697a5791cc7b"
    sha256 cellar: :any,                 arm64_ventura: "d1fc955049d7fca4102b35d2f153f4f80f096914b40e2e8c8e6b0d6067288585"
    sha256 cellar: :any,                 ventura:       "cc1ce092bf6982cdc16136ade457e84352916cb3ee9a4a031c984f3ae2a10b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e24fd9f19433d47109c76713468ef2a921861ab42741e1125d5940bb30cde74"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]
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