class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1013.tar.gz"
  sha256 "fcacd5fd26ddb1b947adfaa7b8c327fc9764d0d38805c9289e47010159139129"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1057d51c9cd14d614352e9fefa9f9688708e04c77e946af1b77d01d891dda9df"
    sha256 cellar: :any,                 arm64_monterey: "1aee15402bb5a95c4dba98504e4d370f8321927cb60b14e448aac682b9302f13"
    sha256 cellar: :any,                 ventura:        "777e12648a90944574d3387df91f9b2cf74eef4f58d954afe8276aea7441b6fb"
    sha256 cellar: :any,                 monterey:       "ffe94a4a70f279553669f8d838141d84c25ede056871f48080a2ae3e5365fef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c845a99f102e9fae53aca8b6deedb1d511ec495cffba3d0f88630c8445fb5cd"
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