class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.439.tar.gz"
  sha256 "fd2bf38626795400dc01eb2e883d4011aee3e2b65c844191dff3d612ef15a41d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd6304127f838707fb6b3a406f668a21850e13bdb6a6d1482fa34742f032f1db"
    sha256 cellar: :any,                 arm64_monterey: "156bcadb23f118d7836c7798a7d4efda87ff9f8da1652b7d65f3885570344252"
    sha256 cellar: :any,                 arm64_big_sur:  "99d8d7ffa4194d8a26b37d4fb3fd74da828b954d886cf7528ba553741d4bfb64"
    sha256 cellar: :any,                 ventura:        "e9711d58ff0ca002d0379245ae3463a005a7d1478abe3ab773d7f50c46950e1a"
    sha256 cellar: :any,                 monterey:       "b9c605b6ec570b6a581a286f65c8369f730fdc7eb4f4e11dc2321e8eecab38b8"
    sha256 cellar: :any,                 big_sur:        "0f0f8773bbdfc3c33e9d8e343de9e2e294cbdca947febab6db1d73a9337275ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238ff356f9e58d848b32bd48f28d805b2d37be5df25ac443a15c0df9d9e33c17"
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