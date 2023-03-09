class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3546.tar.gz"
  sha256 "2ce06c0042b24876b2332e53bbab6374546c0d551f2abb813c0169604af91de2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41b038e10ee7dfa5f5bed60015fb08a72b272bcca24ea7c0026e21a17ac30d31"
    sha256 cellar: :any,                 arm64_monterey: "411ca5d3293396badd57a63b3bc073aa5d62230d5630c72e75c8c356f195d9a5"
    sha256 cellar: :any,                 arm64_big_sur:  "c983e236acad9a761a84a382b62e2dac6f71d421084e5027395dbeb188f7ac65"
    sha256 cellar: :any,                 ventura:        "6932d76c7db78edd1eaadbd8886f4097df6ec7e6a427f940dc8bbd2e1c699c3e"
    sha256 cellar: :any,                 monterey:       "bcace7280913260109d33a3701306ded7e2d9794bda81adfb8ecb820e7c9efb7"
    sha256 cellar: :any,                 big_sur:        "a4fbbec59fcb50d7ee139340fe8d76f53e041c4626f2c9c4025ac90169a493fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe66676f978536221f0bd8a766101bac234d5167814b1e6995c7b5d6739f505e"
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