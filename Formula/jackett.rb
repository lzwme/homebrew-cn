class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4152.tar.gz"
  sha256 "add5cfbe0c341e09e48e43be7de7eb2fd33e9c6765e75bccdffcff47e6b4a7ca"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e9407bb4435008dc3782007d9204d82b4e760c0476c8d4ebce73c9534115bbdc"
    sha256 cellar: :any,                 arm64_monterey: "cddbf9b8f8b19bb2fca20f380e7d809ac72e4356740b09f5c3e539468dc0ec0e"
    sha256 cellar: :any,                 arm64_big_sur:  "cd682d728bcd85d4ade3368d5b2561c941a0e50236825de6b17d5d3534fc0979"
    sha256 cellar: :any,                 ventura:        "e8a68b4d7edf37ed7d0349e5137dfd25def8f1ea4687a1773428adb3c5647796"
    sha256 cellar: :any,                 monterey:       "ad0bf2b72f315b9ca4ce20b475da942f790216248ef0a00b60313755f850b2a0"
    sha256 cellar: :any,                 big_sur:        "a387ac7dc9e692762ab6320c685bf22b6fb27b130ef94d3546033b4754a7ce4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdfde6ab8049df03c3f1ea1f3d3989fccfb5eba4b5fb1b0c9dd44762828891b6"
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