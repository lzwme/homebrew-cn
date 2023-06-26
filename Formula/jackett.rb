class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.314.tar.gz"
  sha256 "36a0a1daf6deb1e705fd039d01e0480ed8807403e808eb018f5616e31d0e95d6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae953989c5bbad534b337867d97a41db2f3e84af8923b1443af99d588c129117"
    sha256 cellar: :any,                 arm64_monterey: "0393168249f53da83c1ac95658af2eb39a7a3c0c0db625a7723a985b35120dbd"
    sha256 cellar: :any,                 arm64_big_sur:  "4baef10a3d952c51a3605f0be902c1f1d4af81057596abc51560af8f090ac029"
    sha256 cellar: :any,                 ventura:        "218fee4738cdfdbded9410453661878b2ee4ae23aec7691a7d26a457d05ae03d"
    sha256 cellar: :any,                 monterey:       "0ec7030c03140ed1e7324be3b9f2cfccaa14f82aa3de3deee3beaa82e67e3b88"
    sha256 cellar: :any,                 big_sur:        "c3a201668120f89837cfed738ed9dfe1ae73a82581478f006879276f380a97a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "708a77d4c7377c9d9b0047b4e66b87382d889a0059fe46a7b44e130a88a9b610"
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