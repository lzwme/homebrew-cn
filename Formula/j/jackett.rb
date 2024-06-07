class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.71.tar.gz"
  sha256 "3636f73948e06d152033de839e3835467e59a919a3a7dd959d572c8304d9550a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abfcddd32fd7c0400381bb852369ce3ef16be9e3dd0c7777cdd887a99b2c13b7"
    sha256 cellar: :any,                 arm64_ventura:  "4f3aaf5776f76359537a43c8ad60a4e767f47ed624c548416f4e6f51a25934e4"
    sha256 cellar: :any,                 arm64_monterey: "aa0508aea1e8f970f680dd915e78549245ce6888cca344314391a55ddabb2c8c"
    sha256 cellar: :any,                 sonoma:         "4f259474158bdc225a7d21fb42e96f1a6c51105f907c79adbbe929df38154788"
    sha256 cellar: :any,                 ventura:        "08d1fd732962320205c04ba0cf549361f62e5ff376304d298f28730f394e1770"
    sha256 cellar: :any,                 monterey:       "0630a4d29ed2d44986652a9858b5be2f23085392684221337fe6dc4fb0ef62fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4901c17e9c6b4a712eb5b388295b10ef6ded35c71eefce15d2094ff57ea70b3c"
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