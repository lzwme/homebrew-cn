class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.643.tar.gz"
  sha256 "4290a1fadc82c3a2cf3fbf6de3b908f9dceba7607fceeadba20598c88ff44d12"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "d197ff532da1bee3db2e4bb20782148a2a4ec36f1ff7493be8d1bc80113397ae"
    sha256 cellar: :any,                 arm64_ventura: "51541d6c129bfa8705459b28bf470fa8ca9c155bb4a7ce1d30a506f0ebb124c8"
    sha256 cellar: :any,                 sonoma:        "a184fe7f26b6e6ac0a14f3813719f653574f0742ecf71fd71f6861003496026b"
    sha256 cellar: :any,                 ventura:       "04e944c2475105e410033b414647d4dbaafda05e58dc5820a6b96f3be13d8292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4752650c5e727825b36f6106dae90d7c3873781639c6b441fe73f3dcad075546"
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