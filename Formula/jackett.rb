class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.643.tar.gz"
  sha256 "8b00629d858946ccf687e86ac1dc6f71e6ca47d8553bbd930999419bf77a2eb7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4c657a5857a6ae46f31d289d7b48034efe2e9fdac574b42cc6edf5bdab8b496a"
    sha256 cellar: :any,                 arm64_monterey: "14e858fc7cc4d11ba92ee0ca1afd70c4494ccd61fdc0756efaf22f5ca4ae1fa5"
    sha256 cellar: :any,                 arm64_big_sur:  "b9cc462fd0b8a9781d67870e77a9bc40f5a0a383f1ccdc19b9c78c4707d73214"
    sha256 cellar: :any,                 ventura:        "dff0619baaaccb4b3a6bb8d48fd0addea7af04cd7db997e2746b908526d68049"
    sha256 cellar: :any,                 monterey:       "3b4bad305492b33dfd4e21081946df040674856ce071f13d3fff08dcb9ef5f7a"
    sha256 cellar: :any,                 big_sur:        "d4242891bdc3d1f1a3293bcc7ee2468ef4e28d6efa91b0fa8cba0ac04fda9b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf8ce3eb2fde3b384990f21d408eb82a33b7c4d60335e896e5175efa56df45de"
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