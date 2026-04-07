class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1542.tar.gz"
  sha256 "fec72ef4b40a267a40c3e74f5512d34b8745561903698f2d12a0c98048053fa5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be9c774cac3357bd19eaf732746e6512c6b57d8098c9ac5f7b5f07689a60bd83"
    sha256 cellar: :any,                 arm64_sequoia: "70a34314b86f4bffceeb45b3430dfab920cf43c02871c5807c623a3503678ef6"
    sha256 cellar: :any,                 arm64_sonoma:  "f2fd8b5355dfc56152bfd10f7d78b732b5c7893d2da58ed315424e8e3a56813d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42cee51804d0b179f94c22c839dccf5fa2d9e1dc2c4cfb9433658e914dfb8724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e0a09700b036eadb07013e2239a76c264fd24a3873b6c08163861b3d4dbc067"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end