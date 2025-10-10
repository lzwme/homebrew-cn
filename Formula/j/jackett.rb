class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.95.tar.gz"
  sha256 "23f893df277d0d9c4a6d4703bbbfaa24b8fcde955eec3906f984bce483a46bae"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d921de366043820ecde63e57e01e49934de6a97f7e91102f98b71d6a11fca91b"
    sha256 cellar: :any,                 arm64_sequoia: "8989271a45684cc4273bb18d1777728931841155d2a8e1499282b4eeac05f8df"
    sha256 cellar: :any,                 arm64_sonoma:  "6ada16df620afb0b8224dc7e12c19ecdd081a1ae8a3967ee2a84770602417ce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d9fd9949a2dc79f6f923101170366e0df25f2780c3c902cd570de1672176f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d7d673965124665e0d4477265876692e10f0107a9fd20811e4fb7a150461bf9"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end