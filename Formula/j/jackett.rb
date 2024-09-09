class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.576.tar.gz"
  sha256 "747e80419b618e03f6ae483a4bc9f86b328a0e05c69612991058a734efb2cba0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8eb0efbdb8dd57d960fe554b4d627cb3ae865ec7353b5fd4bc9d2c55c047174"
    sha256 cellar: :any,                 arm64_ventura:  "e387ef9fd29190628ced2b8fffb8dae298f24fa6fc0f2ca08d967a5280505ff3"
    sha256 cellar: :any,                 arm64_monterey: "22ea495b9e0a3263132d507c94cb3678913df77e4c05d3138502c44589218248"
    sha256 cellar: :any,                 sonoma:         "1eda5b7d3fe39124c11bf1491cc43c047473fc1494c8fdbf43da39123462cdc8"
    sha256 cellar: :any,                 ventura:        "01fd2a336e456f1463f6bd560232961aef5675befb3d007e1c9a278cd6e4019c"
    sha256 cellar: :any,                 monterey:       "b0e2d2987cb5a1acc299463946d61009c166fffea6fa540bf7037aa854a696c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1c19dcf032cdfd1b574c59c0702049bdbd5f8db5f9423bf72c4b50cb3948a42"
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