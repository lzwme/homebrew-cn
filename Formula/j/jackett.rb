class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.750.tar.gz"
  sha256 "912d98965e97d0620787d86119649b3aea88b4a3f383663e1f44f730dd769288"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b057e776cea626015319a865038e7447c6bb768be4fa3dcec77f706ad952416a"
    sha256 cellar: :any,                 arm64_monterey: "e2a6469460dafa73d08dde4161e9adbc1c860dcbdbcfaea451cdc9242c47b910"
    sha256 cellar: :any,                 arm64_big_sur:  "e6d457defdc36e2c33ae80c97cadd154eb8c02bd05cff94c2f06a5115d9ffc35"
    sha256 cellar: :any,                 ventura:        "77947e052fbb4e17e775805c0c897dde91b9b1d6bfef0898b66ecd45f60d929f"
    sha256 cellar: :any,                 monterey:       "d84b3fc2e296a9b40a90e0049784b0128e81d154973bd8c24297695193d39334"
    sha256 cellar: :any,                 big_sur:        "8de6024a4c4ebde08b7c72c6c309f4062b3e32fc1a02853b8625ee1f96e53d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb45cf3efc38c58681d9bf12a3f5329045a39ffa5a0482b54cdac3c3b1c30408"
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