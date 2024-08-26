class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.515.tar.gz"
  sha256 "0ee4e64b04e85eeba313319a36f348814062396d3c2a991ec1fea54876188f93"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6af89d60cbb9e5b38882f4f3421b2de3663f4c70ff81ae91983b4072898a015"
    sha256 cellar: :any,                 arm64_ventura:  "a1aa0584b96dcef01addf2c86e9de8c9e1bc1629312a341c4a2f6b1639b21dee"
    sha256 cellar: :any,                 arm64_monterey: "bdb496a15296c160e63cb3a0b38fd67b29aaa0488ed3dba85e30c744eb0749a2"
    sha256 cellar: :any,                 sonoma:         "73cb6766490f2a21f11bb2fc98997ad873d9ac393ac442d6f45ac5164ee2ed51"
    sha256 cellar: :any,                 ventura:        "fdecd27aa9208601ecbf26094f6387656913636390ec8d2553c1f2f72c5d7fe5"
    sha256 cellar: :any,                 monterey:       "f344e3697c6d37ba2d5f8be5be376e532e4abd621d5be16d9df797a50f7c6e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54c06f351e6183dd32e4aebf88d195b7646e96d5a5dacab2fae7d4b72726d013"
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