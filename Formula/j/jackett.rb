class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.344.tar.gz"
  sha256 "2fc83dbc594994635477a38d7be15335a13a2caeaaeb85cbe447ca340ce9fbf0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e68f9ef79dab801e1b49aeb9254b80d426091fba3014147d2fc35ee2e5442d31"
    sha256 cellar: :any,                 arm64_ventura:  "49facff8dc62b2f20a522004020c984029b9d9b0db274d6fbd5028d71abeb2a6"
    sha256 cellar: :any,                 arm64_monterey: "3a2db3d2740b946563e293fceca76e610b4ebf6a0f3f8026ac3bd7c106cc848d"
    sha256 cellar: :any,                 sonoma:         "e4cbab51b16669b18a57e8482e26a032bc99e0417cf0c1a88bf878fd36046634"
    sha256 cellar: :any,                 ventura:        "84f2f2ec9ec09f3e1df75934e056db5849b50ae62a6b16aead7dacc37bda526d"
    sha256 cellar: :any,                 monterey:       "4cbd7cc34d93689a809b5db767fa98ae27281e73ad90b841e8f22905dcd80d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1978541b22fe3aceb9fad3ee2af850edd778f355edff0654b5728844c3e09d0"
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