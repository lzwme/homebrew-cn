class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.714.tar.gz"
  sha256 "fbd5d2f4cb3b40a03d7fa4fa74c580015cf20cfcff765fce36ef8877d5822dd7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e24322ea10a0cf935b485e8f59d02831d9ea4520d4d6b5a048f6ef0265bbfd21"
    sha256 cellar: :any,                 arm64_sonoma:  "9e9248700dc673a29e9b275cd97ecc11127268cc0cc8b1439e40017803a7e51e"
    sha256 cellar: :any,                 arm64_ventura: "1f830732a344aae2b83e2df98fa2b92f53c62ac7868081d49eeea1294a59fd89"
    sha256 cellar: :any,                 sonoma:        "3b1bf5d612cd155555d0055868056bc06392996ae787eb005132d0dc412a30db"
    sha256 cellar: :any,                 ventura:       "ba7d9955fe0d6dd5b2312079c89e640176d840ba6044430c5c69019cafc77906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d605a576b5d839df0da66b302be7d9ea63d5632303297c7a1b57046aa029e5d"
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