class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.188.tar.gz"
  sha256 "762ecb3cc412483839c0e510ff5d59eb55eb581ed3f8cb8f5d0460bf459ece9c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2a173ae49d4bd12c8b41c51ac05c47796a635d97258c94e1309c3afbea002c4"
    sha256 cellar: :any,                 arm64_monterey: "68ccd126a5706363b0b4e7ea063cbea08ca06e55b79a07af5119ca3c52ce8a60"
    sha256 cellar: :any,                 arm64_big_sur:  "128340e0f92b70bec3635da5daa43027118a5ab969fe61327ab68b6924164b70"
    sha256 cellar: :any,                 ventura:        "27f85237ffe390a285b742ba772cd6d63ee205781c74e60545b84e2022d8c8c2"
    sha256 cellar: :any,                 monterey:       "9f65dcc24766780a09f3e370ad5160f0149e837beb6061d89c4e4ac961f9f81d"
    sha256 cellar: :any,                 big_sur:        "0369477b1865109da7f530b39429eef9dd2ff2bf9903540948de13b5b1cdd260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e320306963c4d1c2e375175358a86f3ef7dcfe54679052259515a191c015befb"
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