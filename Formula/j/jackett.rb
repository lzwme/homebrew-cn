class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1236.tar.gz"
  sha256 "ddfba222bf8a9a956f540f61853184c4aefc6f5054d6729366807a253a722da5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "24ece871d983adffdf35eb416ca124bedf4f6e882d3ad9cf3c1b430295afb7ea"
    sha256 cellar: :any,                 arm64_monterey: "6cec3c110430ef9368daa00ca9d15239c964de86e37478187123ff18dcd6da5b"
    sha256 cellar: :any,                 ventura:        "e248bacbf9fb2e0df7fca239135bbadc3e0c83c87989ee1b4c00fb1ebc064171"
    sha256 cellar: :any,                 monterey:       "92c8e685246d252b666b6796589205b7dbb374610c2bc10a6d7cebcb20b4bb93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b6892f3c1c30bc87dd9a9ea9bd28f8b871697bd3322df7b52e9070b45917f44"
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