class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1468.tar.gz"
  sha256 "04b061032cd44458b13ca247db9b52d6ef4f8510d0498f3b0ff563788ac9e927"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd6c44c51ffc38a8fedbda7bb493f1719202f17de4c936d592be85ff4e56a506"
    sha256 cellar: :any,                 arm64_monterey: "46f4c684e7f37cd4d402eed2c9f269f3a7944d1fe3ce769b4697fac23b0a2e19"
    sha256 cellar: :any,                 ventura:        "1390b0a446c5f5d741b614e8b3fd8a20714aa60c5e3f816fdc996c5e70a12333"
    sha256 cellar: :any,                 monterey:       "fb673ce05e09fb2228685e685a8a39391cfe3699a1b2322398619d11782822eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec5b8abdd4cb42bf33b3985dd09d25a3d2af05fa70c114f3df2f86ced2361fe"
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