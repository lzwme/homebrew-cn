class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.95.tar.gz"
  sha256 "920bef46a245f55ad35196b716147d4dcbda43f55c9ec64b87a91c7b9923e9b2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c70f66df91f55a4963284f9bb4e561204a87a29dc96d8bd89eaac2162494aa9d"
    sha256 cellar: :any,                 arm64_monterey: "462647ee5b549a5b43c1706df8dffe2dd746409788877f76943197d6174bea2d"
    sha256 cellar: :any,                 arm64_big_sur:  "62910cc8095caa8bb1c202afa210bba761d9679b07e06c567c61f9b3799ba9da"
    sha256 cellar: :any,                 ventura:        "b982037d9693796cfc621f5780cba244a875c2368c6fbdaf86efb2f6c8f9f6b2"
    sha256 cellar: :any,                 monterey:       "7866c03edeb4b78df781a96838ef447fc37c3ab514dbf3cdffa8fd4ee55d1abf"
    sha256 cellar: :any,                 big_sur:        "391b9c258510f8f406db5d6e865cf596ce1464ba8e98098748bd5ffb74802d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66bfc7e71eb8acfc090eaba041caea9dd65fb641dac4ddac7d49001e07261e6d"
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
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end