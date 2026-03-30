class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1485.tar.gz"
  sha256 "3ee5922626eae01496b39f4f71013ef1e414b79b8b7e24125529da2a975320ec"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbbcc2f63e6f8f06c490936a06c6ec1c94f7cfb977422e36473f8b9577ff4071"
    sha256 cellar: :any,                 arm64_sequoia: "f2f8b54afcdc3b8120e8b3ad19c6719408376e342372cadf85b720295d4e1a8c"
    sha256 cellar: :any,                 arm64_sonoma:  "9d8258490eb1a99d14a6678aec11914cc04d4d2248a1e45a7c433a79c065bcf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b16928ac4afb1d8f721dccb3a3d50a570720283c05545859f0b7a2875665ae92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a8cc5ea83cd691381d8d45784cc0bc2205a70bf0fe5657f0fca94441c54e6f"
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