class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.879.tar.gz"
  sha256 "54e4c1b44644f3cf49cbeb1551b6a293d054ea35154c69fc2ef9ff284d2ccfbe"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92ca579a6548771612f04ffdc7b7fef24e1b9e1615de98c8db6542d638a0a9a6"
    sha256 cellar: :any,                 arm64_sequoia: "6d80ae5419c865dd001987b8de1211ff4ba2accc92d0b94450f2c3acb15a9d66"
    sha256 cellar: :any,                 arm64_sonoma:  "7a14d1dbe32d3d4b216a089860f2764e492fdd9d247b9a1605c09b989df3e30d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4744115467a8ef0cfab61c79223d2a34b06abd87e6d4dc420f1aaf1ccc50c088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "718c244c58f9e87e49263c8a425a736044e16fb0ff997bbdbecbd0e0d6ab201f"
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