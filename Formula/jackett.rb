class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3917.tar.gz"
  sha256 "1051a04214675d05ab33569c976f581e2939689719b7923ae6cb6a4411a2a9e2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "28f7ec86463b7b6115a7de42c6a83395f00a2c91d0e69270087846041583819f"
    sha256 cellar: :any,                 arm64_monterey: "4f269239514496dfb04b61886b1eac7051b690a72000d7ad7625eae61d90b94c"
    sha256 cellar: :any,                 arm64_big_sur:  "a48216a1a0d1b0cd025859c7454c38b96091d4ab66037e052eb4fbd1b7a54f90"
    sha256 cellar: :any,                 ventura:        "bf67d05e82e93f935328a9e6f7e030f632124716aca41a69d719275ec51f7627"
    sha256 cellar: :any,                 monterey:       "484bc3474168a0501b5df655122e248b30bc9558b6e2d49d2e69a5431eacbf39"
    sha256 cellar: :any,                 big_sur:        "d1ebe0c878d0625ed16b8aa2336e33d7cbfa52246baf1ec6769e25d5effdf1d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d86690aa85856f7c752ba8bc65a3eb078a7da10eabf2042a73a7ec7cae378156"
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