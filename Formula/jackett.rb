class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4083.tar.gz"
  sha256 "062096a19a905ca98b75c358575d99a942761b5aa354812c0b48b5af83ef554c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "24e9f38d2d25a7f7ba23bf9e793d276dee114959c65db49d16558f7c8f389bda"
    sha256 cellar: :any,                 arm64_monterey: "ba9570d02c56453d54147ab03eb126d24d35c1bf269e70f8ab48432c3187597f"
    sha256 cellar: :any,                 arm64_big_sur:  "08abf8078684bcf0ad9f0d920a67b5ed638497b9e3a6328417ce10a19911109c"
    sha256 cellar: :any,                 ventura:        "c6a1c45175565b79dad45c08c653d4eafadead273b6d5c8e9fbb350ac73c0d61"
    sha256 cellar: :any,                 monterey:       "f934412c9b2f58c81bbb851c780c8b76d065a34046ede14bc58a6de9c8ef86cf"
    sha256 cellar: :any,                 big_sur:        "1d90cb80613520ac99d14f7ec3753d2252cead191f4163e79f3a940c7ea3c76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "941133a72642278932aa01f89544c845336dafb66beac7c8739a9f01ecc7b8fa"
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