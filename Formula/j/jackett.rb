class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.817.tar.gz"
  sha256 "5b1669285fa40da6417ec96b79024373b0c50018be9c6915dc28efd83d529c3f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "255d5c7b5ce61b0e417058b4e76e9570c620d9e8edfb3fc5f890631b840abf14"
    sha256 cellar: :any,                 arm64_sonoma:  "2817be833a213aec1db4b25364e5102e9c26bdcca75fa80838663ba8aed68a00"
    sha256 cellar: :any,                 arm64_ventura: "d2f43ef71983a5b5510723e6ace883851e291cc4a5da88bbfd0d63893f5e1074"
    sha256 cellar: :any,                 sonoma:        "a38fbe7d152adcdcdd58361b47db8969761578cc1d75bf333ed224979050c553"
    sha256 cellar: :any,                 ventura:       "87776480df6b284eca8815d2d57f3cf8828113af5d6ccfa66b841ab1e50d1915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "522b15119271f33a3add9599b5ae85c3ef4eb653e2a223ba805f09e3b89057d7"
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