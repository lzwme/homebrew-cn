class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.813.tar.gz"
  sha256 "b91c855c8ff92eb95d385f50d4d8fd00887c7db578acd034a3dea39a50930d47"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f563340da3610568e1c301f9884916dec4362d57c96a01c92f240b17aa4e80b3"
    sha256 cellar: :any,                 arm64_sonoma:  "ae6727d49565447b643c73fcc07dd2cdfa24c8e47fbfb7a6d4c690960333b702"
    sha256 cellar: :any,                 arm64_ventura: "5f5a866a53d8a866177670f803ba2d938aaf5b82135de80af43c2d8b1e6b1df9"
    sha256 cellar: :any,                 sonoma:        "c68eb56f5daa2c5bc83e476428884fd09f5e43d171d10df8d1a9b4aceb66014c"
    sha256 cellar: :any,                 ventura:       "349cd37a686a450406f1112e7889bc3efbae251e331adc5ce9743f3da15903bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d6f8102457416f876b9d8b874085e18edd45a5241244a254f72bcaa030a24e1"
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