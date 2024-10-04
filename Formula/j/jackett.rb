class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.704.tar.gz"
  sha256 "92567217b889674fc67e3a48047ae78e6ba5e37b429259b050dce97ac194283b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b07082546228d24ea0ae9c9a24f4b878a3883bcd05ffde9db2b19d3abbc93a64"
    sha256 cellar: :any,                 arm64_sonoma:  "5c12655f85d2ee658872eca467d730546fc3e5548146fdefe0c25ed39a0d153e"
    sha256 cellar: :any,                 arm64_ventura: "e2a5daa175c5768486102ff5d72feadcbfd636fd2671aafea0697f39231ea981"
    sha256 cellar: :any,                 sonoma:        "1d5a892e506e8c2d9d00791fce178cf66e4cf24de7ccf3d467add5113741ae85"
    sha256 cellar: :any,                 ventura:       "4a43c5377308f19375529c046e44467c76f69f334787f99c833c0dca4065239a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12998220d3ed7bd685b829159d3eb64037d8009375d16a8de4fc261a5518eca7"
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