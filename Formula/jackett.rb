class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.456.tar.gz"
  sha256 "a687a4e8a590dface91bf542ad15444bf0e5647131ec26ef8f72bc0e3efba43b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "609f6db88f5ec19dcf856426dede1819eee09bc33ff4d0e79143045453f96f67"
    sha256 cellar: :any,                 arm64_monterey: "c6ce29b16ff4d194f1bad832091c0a64e827373bae306472c5b37bde08d93957"
    sha256 cellar: :any,                 arm64_big_sur:  "27793269265b4b177261a1ac77a49b0943c7f9888b7955efa03943e319cf7e59"
    sha256 cellar: :any,                 ventura:        "9a51dab94155376a4f124b1e8936bb8185209c3d2d03d32130a4c0e254bbfd97"
    sha256 cellar: :any,                 monterey:       "82c3473e06e56fb44376d6931dc6c3f4a9df9e6bd9cf1f6633756d2c0d66f518"
    sha256 cellar: :any,                 big_sur:        "70edcc953edb397085eb0723a7a3f8ab6889b22f047f4d28238b3bc42c75af4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "020192ca6077dd1f359dd342284787c6dd0d5fd1f587b779d6007fb47d5e1562"
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