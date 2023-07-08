class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.424.tar.gz"
  sha256 "96d50147a714713519a077222ddae3d12fa8db586761377af802deeee70b39ad"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c3ac2365743ce5c163906e0cea68bbb3e1e52b328cd48e5ca572ab9359f7cd61"
    sha256 cellar: :any,                 arm64_monterey: "724517e4029065c8ef14df4032dadd5f1192a1be2950d3e14007c289986343ae"
    sha256 cellar: :any,                 arm64_big_sur:  "e2a7132e3bd99832913cc4f2717b3eaba35fed9e558fad9bfcfa717b54ef343b"
    sha256 cellar: :any,                 ventura:        "1e8c3198eed05238fbf3a228a14310b0f4a35154f07522bd293f7c216b8eb5a6"
    sha256 cellar: :any,                 monterey:       "c5a735501a33d3772619bfe847c4f656aecba989086389c8126c3c7ff0d8358b"
    sha256 cellar: :any,                 big_sur:        "e713a6630ceb5911b2aa2d79244760ef1e19d8879aa7078cf3e3521e3dc7cf8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc8c7243f3d967994ea7430ba89e983a5888d2c9108fe3a6a8e4fc49dd4e1239"
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