class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.398.tar.gz"
  sha256 "769c1e2931edfa3b28fbf7749dce7b94b8238f56c025de7771b3586ae4bd64ce"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df8ce2a6f83b6e4a6505eb78fdbb1154faa4d1021d5c2a498737cd60fd193e8f"
    sha256 cellar: :any,                 arm64_ventura:  "01022f35b5e86cc55f59126f9fb588ea245e4845854a56a026ebd425e61819d5"
    sha256 cellar: :any,                 arm64_monterey: "86371d92130724169609e9ab15c5186fd642f66a2bb1e2dfae2b65625aa3e65a"
    sha256 cellar: :any,                 sonoma:         "8b6d2af1f4e99f7b595f28482fb01d9de8097ec07cd2c72baec074b12a85e470"
    sha256 cellar: :any,                 ventura:        "1d23e379c4a89afccf51fae73c7b4ff15a88347c4a47ba86afb00e2706194ac3"
    sha256 cellar: :any,                 monterey:       "d44354e341eb912c8f27730a11e4ecd80ae40c97b345493173865e9264ee63c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb282b0d896acb826b9ab5c980894d09d9afd1643a2324a9bf92e0db61f7e1d5"
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