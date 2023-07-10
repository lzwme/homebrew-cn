class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.446.tar.gz"
  sha256 "675600cf407c2e629196e7a9a851c8fda83f0b8e659a4128b5b319fc63267a5d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "937ca4917f435533f9352b306dc7333be2b3159b2cc15ed403136f2999938503"
    sha256 cellar: :any,                 arm64_monterey: "d201a75299056486ab2052213d6455954b44c51137070b406afaf2e07588818b"
    sha256 cellar: :any,                 arm64_big_sur:  "dc3c5ea2dc5e87d45e58157f29f5befffb6ee3debee835883468a22b1480f880"
    sha256 cellar: :any,                 ventura:        "578b23b4adddf32e9085a596e4f879494fa88244623b154f0d28b6e05c03092a"
    sha256 cellar: :any,                 monterey:       "8d933b97dd8a426b853e619c1f72fe1b7d282baf0dba67ffe797a271780959d0"
    sha256 cellar: :any,                 big_sur:        "3ffae7f476108eb9da33a8d377a11ddf2738eb4a150bf127a3e36579a6fd846a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1966c93d0345619d25298ac87f659ed1dc1ca83f70accfe3813670c08577df"
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