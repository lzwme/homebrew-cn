class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.76.tar.gz"
  sha256 "4160c11e268a3480dec9cad76cb607e678802a3bc9249cabaa25fa9a5a63c54a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "acf1e3a49113cd3aee930f47f4b64ef3857e26fd38941092918decdb80b6f3e5"
    sha256 cellar: :any,                 arm64_ventura:  "67cbcbb3ef792ee112f3d2a55b60a5141f9a5a0ab59b552cdc3999e935b517f9"
    sha256 cellar: :any,                 arm64_monterey: "708df5b3462ce75359a35493be052ed6a5cfae0eba6d871a9b951122773601d9"
    sha256 cellar: :any,                 sonoma:         "d99eb443758abd2890de2245597149f9c2f6f78cfde31974874c5cfb361cf836"
    sha256 cellar: :any,                 ventura:        "b71462fe5a5f2d1df41ffd721488c93634be9b7cdbd60c30e7fefa675da74ae1"
    sha256 cellar: :any,                 monterey:       "7b1e87bd22abb06cf09810cda65678c196ff3138b8c2b9ca3acd45eb602309e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1095f6eb80b6b85204716b133649026704b40d7392bf9cf33f1aa61e703def69"
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