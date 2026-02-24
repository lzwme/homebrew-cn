class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1184.tar.gz"
  sha256 "3eccd70280ae984f0215860b66c8c650f5d9d3f1f40850d8730bd5c94dcb1149"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7b8689e1de73d7ed3d4c06639e44f6c1dabb2df2e14bd9e4e82ae00c6904629"
    sha256 cellar: :any,                 arm64_sequoia: "63498235ab88586a84e4eda5fca9a39a4ba5e6f0352331e1d5adfa193987220f"
    sha256 cellar: :any,                 arm64_sonoma:  "d02b05bf333c022c8a1cad6bda53c198828a48964f3b2db8aac5f476cfc780a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92d6fb0be7cd9089a4e579be7eb75a1a9bb96a1a476146e2fcef626e1a8dc19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73240b2283eb35436b16126129ea1895c70d6fc6ff65a541072fc20729d9b06"
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