class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.807.tar.gz"
  sha256 "e7b7939201cf00824c839b417b6fa33ef4b72f261d7e6aee86fece426304394f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2aae7d3ea8abd9137d12371a78e5107c19a28064bca775fd07cf43de5050743"
    sha256 cellar: :any,                 arm64_sequoia: "f379996cf88dcfea7cb238b53c38b119b9350665e0ffc315d4becdba00b6d579"
    sha256 cellar: :any,                 arm64_sonoma:  "97a326e09e17253917750f3989925eda0fa84be1f2d2a4685a9f34f8f4fc1548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2f77412fe9bbd7129055f852bf4992672de5c82757d4fd0c5bcb4fa7f21835b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18eee4a27dc46e1eedd264f5a76552391eae883d904d93987c0c0166e143bd4a"
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