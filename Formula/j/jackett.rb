class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.946.tar.gz"
  sha256 "d181a575802c49886ddca7ccaf9b2b7a30cbd8b4d240eeab91c6b14293d033c7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b89553763c118e38857a2820daa3ec38560d0325adbcfdc00a68629e1ecaa1f"
    sha256 cellar: :any,                 arm64_sonoma:  "25b48c0b576c623aa707835c8d7b6bbcf3751639a4dc368248f6d9caa7491dbf"
    sha256 cellar: :any,                 arm64_ventura: "fdaadf9c05cf54f640fe72bc5ed4be0efa004ec3993564017a8cde0040c6a23d"
    sha256 cellar: :any,                 ventura:       "25f94d59774606bfc9b32b75bed79570b9c517e5cdeb10c502c3e07735edb7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d77fec51e337752d3d37c5a263f27f03a8e309ac38ab11205352fef4fcca1d"
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