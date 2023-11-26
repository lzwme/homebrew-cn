class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1256.tar.gz"
  sha256 "d6b93abaf9c517f578004d0fc0c5acaa22dabcaa3bedec7d11b53e5002074179"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2c6576460927eca34c22b5e6e692aa254a5cad1c38d7e62ebb65ce38bc1d2e2d"
    sha256 cellar: :any,                 arm64_monterey: "8df36aa2d01ea861cb63caf46077b99c5bd79f49c2e34822501581917d96d941"
    sha256 cellar: :any,                 ventura:        "45758ef0b770466b7eee00149cde96d89cc21c6a441c1e17e05f2930432a5353"
    sha256 cellar: :any,                 monterey:       "21b18917d6997d1e5b55bd748b6b3083682f7784b9bdefbc0839b9601629e4d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19285d151eeeae5fdb3f88e34c5066ae4c4675ad485d7eb204b7ad6df085811"
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