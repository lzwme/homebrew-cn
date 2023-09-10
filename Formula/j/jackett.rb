class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.763.tar.gz"
  sha256 "ce0fc6f3ff0f31f5b0550d0e01f8d629a4869c4b94892d3433ff79d78510473d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d64ffefba641e4e314c85dbded176cdf99706a93f0c996bb7fa7bf0abd6c1dd"
    sha256 cellar: :any,                 arm64_monterey: "1043785be36c8f404b741772ea8da2123aa066c999db0b7f6df7d79243e70148"
    sha256 cellar: :any,                 arm64_big_sur:  "28d025bd5150bb9ba8be6956d22175e930f2e956955b355689f287a6d907b672"
    sha256 cellar: :any,                 ventura:        "bcb1447da598dbbde1468802c376fd3134fe6ca7385dbe74fc37fdfba70d991d"
    sha256 cellar: :any,                 monterey:       "d992d576eaa002c1913390a8fc5970d29dee752bf0904018eeba677d9d1a7c02"
    sha256 cellar: :any,                 big_sur:        "83a13fe25e76c114b9802b222e22489f33b9faa6421e0b64082366cf2196f882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34dfe53b25e1bb6f0040ab05298700c98c7c39fbd2a1ea419b253e45ed087b4"
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