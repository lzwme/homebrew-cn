class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.88.tar.gz"
  sha256 "6bbc07e6003b9c2181f42ff32201d9cfee580a53afd4e42568d1af980a829217"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aafe881f9c65d3c0e57ad22279a187379cde76aae2e9347839e5bbe281833c9e"
    sha256 cellar: :any,                 arm64_monterey: "8b9d078cde218d2f5615456698fe05330721ce0e674da95f6b239579888cbe8d"
    sha256 cellar: :any,                 arm64_big_sur:  "868106b7655c600725d65b0b0deafa052cc9936d334ec33773b1a1f81f99e43f"
    sha256 cellar: :any,                 ventura:        "1c5508a1ded5869b595546c8733fd0e4632453ffdd2aafc54db09eb30bf92a60"
    sha256 cellar: :any,                 monterey:       "4e74292977c5e1c85e6a07c033d4ae5cb688f1e084065ce4e72a4c987d04140f"
    sha256 cellar: :any,                 big_sur:        "4f7f2cceec215d9f143418af3ba98141f4e8496a32e510d68facde1c7cb6ad78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08c50a56ccac8613dcf477128b45be97c65f4505a28a722f78c952f5816710d7"
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