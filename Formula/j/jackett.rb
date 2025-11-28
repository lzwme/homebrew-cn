class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.361.tar.gz"
  sha256 "60f12678fec5f9dfe90f6ba14df1a81116bd8772544d02909d5bb03cdd114a98"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dfbe1f6feac663ef5abc18709edad1141f875c062ac91ade430386becd13b87c"
    sha256 cellar: :any,                 arm64_sequoia: "2731cfa5b9010a9f6c315109ae57380b7de7345d2dae1b0df255b484f52e9787"
    sha256 cellar: :any,                 arm64_sonoma:  "9aef082481025575a6e38520a01dc2d118890e76eab822b60d3ccd086ee1eba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1def126528a5407e6eec365256a8497db5bd0c93966b0d67522bcc0ce22bfc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa10ac6ba175b891bd160b26456cf7c8d3be68e69bef1241710261dcbf50c4c"
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