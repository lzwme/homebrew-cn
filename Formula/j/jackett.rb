class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.706.tar.gz"
  sha256 "63509ad9fd47808f9c3d785ec6baac38dba2315ce14b1bbcb3fc50cbcf271eac"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e119a09d6010800dbf8cfee34a2d972c1de04586a1665360cf3251140798c2dc"
    sha256 cellar: :any,                 arm64_monterey: "4d5333ae8ecc724d839280e9e860cd8ef49ea1552216f3e50ce2b5fe5d930fc0"
    sha256 cellar: :any,                 arm64_big_sur:  "b6cc0f93c64e8932436693e15145f1f40fb6001f7b051c36436f69aadfcf49a6"
    sha256 cellar: :any,                 ventura:        "9bb4fd85b263b2bbc91fe6a726566256fe74cba326453f68037f849c9dec18d3"
    sha256 cellar: :any,                 monterey:       "31a010c73c0169a4653fc904cf139503d8780d915b11222c2f9cd9698c32f2f5"
    sha256 cellar: :any,                 big_sur:        "fbdda6b9871f93c3d381b256661488cc6e0a91a14bc0d6d369118417c00f3531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dafbb2fb078b3e719ead9a97753ab4d1f868df001d29efa8ae3f229fdb164eed"
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