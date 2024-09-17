class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.618.tar.gz"
  sha256 "3d3f093df1a4ec226552bef969e0623c4995caddb45796686de2b1c4a84685c7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "9214422972e3c5be927d4630ee7e25192f4f8b3777a1434029455005dc0535f4"
    sha256 cellar: :any,                 arm64_ventura: "35d2d49d0d04f3d48c23ebfdda434c2f99ba3b714fc2bc544e43554dc1f83356"
    sha256 cellar: :any,                 sonoma:        "02c2a8f42047654d8e8d9c65c3111710915adacc28dee30ab34c270385728d2d"
    sha256 cellar: :any,                 ventura:       "2b970416cc5a4c2a8fff25fb93b448e418cb7af2d8196f152871e61022365d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba824c59fde9fff4b78be1f30606007fd6ff78bacbd2ad9db463d70112042bfb"
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