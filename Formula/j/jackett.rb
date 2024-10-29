class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.856.tar.gz"
  sha256 "ee931f60ece96860313301e1de7344f6b9734e7a86614ef827f5d7337809012a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec338c3c831a22e043123585d118b00bd7be2937047f9cbc9aa9a9616d598097"
    sha256 cellar: :any,                 arm64_sonoma:  "b8b2ea763f2649decde124c465bb41b0cd84a41b9c13fdf341ed53489c39133a"
    sha256 cellar: :any,                 arm64_ventura: "a1348a23984cc60bf1db1141974bc9ce0cc204822961b4c47adda00d6e089324"
    sha256 cellar: :any,                 sonoma:        "5e4f13fb552ae7109af4126cf95265cc29ae24349c51e7ad250efa0268d123b6"
    sha256 cellar: :any,                 ventura:       "7fe3ebb655cf083dbd9c661cce8493bcbcffd81d2dfb58f4e1a428a6d23a4926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ee64cdb4894b5a30bdc41a0c6bd808b8c7d9f6b80762ab9ce546f1372fb7f5"
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