class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2173.tar.gz"
  sha256 "088a4c830c8f03e40cb331f331191fbdf25459c69c3d75075840a8110e0ccb70"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "362ea772159665640f4e71c97ec4ab97d4109ab22181aa5021be53edd15a1094"
    sha256 cellar: :any, arm64_sequoia: "2ead2e27d4ba6769e34e9949f207ffea8ee46fb38c620b4272760984026e8998"
    sha256 cellar: :any, arm64_sonoma:  "d21ca8d5b003f6f678a52563402181e35b31f0be4c89ae51bc9e023fb4698981"
    sha256 cellar: :any, sonoma:        "01c01e6024f6e0efabfb666cfba02d3ba15a8b5b1dc712107d4f3c470e6d7a3c"
    sha256 cellar: :any, arm64_linux:   "02b32ec332d2e63a0905c971660bb6eae365ceebd8ae3151a9c12b9ef04eab3b"
    sha256 cellar: :any, x86_64_linux:  "b84daaf311cd680e13d4be9f3413f7cc115b889dc52accc80f1c717b053ce8d0"
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