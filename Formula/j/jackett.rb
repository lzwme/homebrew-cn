class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.119.tar.gz"
  sha256 "7fa0a9b72f93c405d520e26aac6a4e09c2b721fd4f98a1ff12842ea81d6752c1"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "055e8a4d9670a182c396093d0bb159925cde163b2922c34fdb797d7bf61c25c1"
    sha256 cellar: :any,                 arm64_ventura:  "77a081340de29cee6bcb3d5b76ec0f8441dbc661e6f7b854ecfdd5545a980176"
    sha256 cellar: :any,                 arm64_monterey: "3375ea1387a4aa3fa698eb85c321088bc4eb220f261f235e362fd08375302093"
    sha256 cellar: :any,                 sonoma:         "f9348a2c2bcbbbb32bf345b6daba5fa938d6f2a6913824104aec468d36909116"
    sha256 cellar: :any,                 ventura:        "debae636053bf67bef8cc600121df88e0e028c982700765faaa18fe64e3db59a"
    sha256 cellar: :any,                 monterey:       "cbb51977297c9f415f9d21794520895f951dae66a1e2b91777a3ac465d23817d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e340753ae2d5671f9a717d34b96f9fe8da5bada5a0175a6e413df969502598cf"
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