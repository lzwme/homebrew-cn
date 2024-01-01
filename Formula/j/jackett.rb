class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1465.tar.gz"
  sha256 "019d50106b084221708595dbf5d283cec8e2b1efa5880e4e967e5200983c37c9"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d040c3c296517b2501369bd9163391a395243621f46aa65c1b4298eaa3641102"
    sha256 cellar: :any,                 arm64_monterey: "61cfeea38371fe673f5d303e4d3a3ff445be2da6c50fd63bd95d274d2c6f7e05"
    sha256 cellar: :any,                 ventura:        "37544e8fd9d6c1571167cb750d987d694e284d513263ce5ed62c1e8f969fbb19"
    sha256 cellar: :any,                 monterey:       "6fe192acffb01bf6dd7340c380321e482f37918dd45f19333ba02e8c989d9507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbfefb3b0e3179df57e5c7aea6a4c4b490d7c9bf733b69112c7d24e9898c6f6c"
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