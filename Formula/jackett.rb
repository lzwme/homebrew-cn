class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3846.tar.gz"
  sha256 "8d565e134d2ba2a48047819c5985d3dca0efd5114a0169be2ff4be9b12c1bc62"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2b4fab64c83371ff804b9f1eeb8ed79039b6df7cc17c0c4290f124f7cf4089f8"
    sha256 cellar: :any,                 arm64_monterey: "c06e553c70e6274b35cb976122d474faf9231734380d9f369230cdae3322a444"
    sha256 cellar: :any,                 arm64_big_sur:  "d7dd267b979d76c50c545bf8dd7d92c64b5782ac9c3e5214d04901068b2256a5"
    sha256 cellar: :any,                 ventura:        "2efb3df494c8acb5afa7dca122d8718d54404d63e05b6dac542fd2594b4ca472"
    sha256 cellar: :any,                 monterey:       "27fb2bfa012440d07cb0949a0547c52759158ca1078a8b5f9cc6a2378ee60b0b"
    sha256 cellar: :any,                 big_sur:        "55017b1265484de0fe813a228cdff2cf095de93315642a44d0dfc9c910054f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f0d95f591fe00d8a1ba70de484a77c9a36f4a51495babbe780c79754fe3a4e"
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
    working_dir libexec
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