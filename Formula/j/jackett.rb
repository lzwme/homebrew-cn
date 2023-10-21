class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1056.tar.gz"
  sha256 "18cf6141b8fb9ab0063f334797a911cc8733694022029fb7a6e341eb5e1898bf"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84475c9660a2dd11479cedc80a0c7752ea4e2872749d692c049b4e58de3a8ffe"
    sha256 cellar: :any,                 arm64_monterey: "18793779f42c74942c15d0af2f61b6b59ccdf297ecd3671746e48e70d656963e"
    sha256 cellar: :any,                 ventura:        "b82836f2df14692a4dfd50dfdf45984fecac2d7d261abfcbadc3abdaa19a2a1d"
    sha256 cellar: :any,                 monterey:       "d3716a44a67798fe8dc4eafb348575e191f6fb966686bf58ec330a39fc6e313a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204b759ed4b6c5df74db59c0be72f2f5a862276a3ee5a6ce1238bfda1e92af37"
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