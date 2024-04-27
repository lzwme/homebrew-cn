class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2476.tar.gz"
  sha256 "5afcf328a5e07c603dcdf07713141c318865bda201c72ad0a1bf4b32b21c5576"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5875f800c050bb90c7efe426bfd9e69055ac60c470b930441cc18184865aa543"
    sha256 cellar: :any,                 arm64_monterey: "d51d9ce138221946eac2b7539c168fd384450431c40f18f8d79a557ef28291ec"
    sha256 cellar: :any,                 ventura:        "c19985aa3cae462870ae468eb8f22cfc06a75f65cde210add15ccc96ae0b4dd2"
    sha256 cellar: :any,                 monterey:       "632fe123506447cc0b63fb741367a41b3e99b9b23dd9fdccf47894a3801caf70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e262e646ad0645cdd2405a245bd02021239fe6a81acbc3f36119e4d2d45f5ce"
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
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end