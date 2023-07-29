class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.551.tar.gz"
  sha256 "37abedd318374e92f188988f8c2361f8a31291be609f3933007b52ad4fc7928e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "72d974486cd9d38e53fbaef2e08250030b1da129b44ea4c11a247d97bea85204"
    sha256 cellar: :any,                 arm64_monterey: "cdfcbc79755efd9fbc4cef446892b7a5695a648d60e543b3ccad899b83ae43fb"
    sha256 cellar: :any,                 arm64_big_sur:  "2c7a149aa72d4b45488cbeda42e4f8782b555075264795e8df26c98fd453693b"
    sha256 cellar: :any,                 ventura:        "1697b12fce7e3674e1e77ccfd37ec0a5b937d65583a4b188476e9e09f67e1f9e"
    sha256 cellar: :any,                 monterey:       "e0e13cbf58bd169de4ae7c1fd8e4050a576ba453ac39dad8edf1d14ab02a667a"
    sha256 cellar: :any,                 big_sur:        "0d01e5f9aa8c1d78bab1fd34ab9c33fc775007bc0f6033403d1edbf8095225ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "312f3ab99343eb9a6b06a47d7d077d2d22a2bcdcbfe22222eca6c834cba8dc7b"
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