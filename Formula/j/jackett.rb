class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.444.tar.gz"
  sha256 "c6327d863663c72266cdebeeda4518575637de1017dc5181663e952cde1d4777"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e2b553e990835b27adfa13924d7f8cf692c8b61ecd1575ecaac9bc206cb94251"
    sha256 cellar: :any,                 arm64_ventura:  "78b80c8b4c897159bc39c3a4848632518517614d9a0d9f34291c8cdff56a03b4"
    sha256 cellar: :any,                 arm64_monterey: "888d74ab8ade39564e6e5116591a104ba697c611767e69e1aab16139563d3c32"
    sha256 cellar: :any,                 sonoma:         "313e40134773636d19c821e06bfbd9feee7992ef99153c88c5f2498e46ca5ba2"
    sha256 cellar: :any,                 ventura:        "af7ca64feb4952002ac16a81e2ee172f2146971b1776e81828aed4b686d055c0"
    sha256 cellar: :any,                 monterey:       "a21262fb15a76b2f73a37f010205f7856fc674728e0179c8e40c1600160241c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f39bd2a708df3c7ccb00287790fac538061dfeee8190b37e688374f77f47268"
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