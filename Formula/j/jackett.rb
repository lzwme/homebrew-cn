class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.841.tar.gz"
  sha256 "ff66aecfbe9b856c007c2e5523181ba01aab15ea1687557ec05977651a667cbe"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab590c62ac3c749a030c4ba37dcad66a27450f7486786d2acf12440a14ff10ec"
    sha256 cellar: :any,                 arm64_monterey: "33d657db0806182d802383501b2c41cd754271715813e60f39aabbc95903ede8"
    sha256 cellar: :any,                 arm64_big_sur:  "18d93b5a6cea971671efb77ebc175861b650b2a330c0d16b3d433829271cc189"
    sha256 cellar: :any,                 ventura:        "57d759959eae8d0ccac89f0d70ffddb6448caf6a5b81c54fa09adf62cd0f901d"
    sha256 cellar: :any,                 monterey:       "268b8ce0ab7922652dda5dcf0ee0763a1150eb05545323b37fca64d4a120e9c6"
    sha256 cellar: :any,                 big_sur:        "bb7f2022c92247e62768a3f78db44a63dfa6e543c3b3e2ed6abdb2ce2cfa70fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15b26b623eccd22573810a677a2f107ac2ae26039a6c1f15e001f54c8cb303c5"
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