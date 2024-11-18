class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.950.tar.gz"
  sha256 "b2cd562ba16042586674b146b8fa771387b6b2a2f0c653ed1f4d2d348c69c5fe"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d2187f6a44ba5db4fac9b89408976d17e823f57b6ac39c3710d264cb314a22f1"
    sha256 cellar: :any,                 arm64_sonoma:  "97ace4f069d08bd5fc47b3f4457bd0c922499219411f77793cd6dfdf8b145f16"
    sha256 cellar: :any,                 arm64_ventura: "282396221171d70440a7d7cc34fd2e315f9392eca646ca8f978bd6a99f7bce52"
    sha256 cellar: :any,                 ventura:       "015eb94f4b57f13c35a639caa4bd55c92888a9146d842d09f4b4b970849903d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0853807c9d58fcc42cb22278d362593f86cee80e91569cf3f671b32f83ae9a83"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]
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