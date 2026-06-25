class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2116.tar.gz"
  sha256 "9ba7211851739b59ee61a71c9e1419dd9b86b0ea0f073f8b67bea015df148877"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "71e20513d6b216af4085345f68a16b105ad40f98310889eed196751f1b4aaa13"
    sha256 cellar: :any, arm64_sequoia: "c5a49a2994abfcbc62e3a4542291ff958aaf1fb3732244d57c04d0865e97af56"
    sha256 cellar: :any, arm64_sonoma:  "c19b761b8562c621bfed28bf77ae9eb5fbbb27bb0aa1d7c98872e40b113904fb"
    sha256 cellar: :any, sonoma:        "d402d43dc51d03a8a7932b3fe758665329c10989d7b12a10fc44011b176a9c22"
    sha256 cellar: :any, arm64_linux:   "8eedb1ef94cebb0c59374b9dbde040598ae8027329b112f163b4d4e379073db6"
    sha256 cellar: :any, x86_64_linux:  "75efdc53d3f743d108968e08f38cbea6d7a6792cf0f93a93561e44a5ae5013c2"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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