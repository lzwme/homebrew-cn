class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1003.tar.gz"
  sha256 "70c7e90aaad9eea8fd6f3ccde0511fcefb618a4ed7311db76b3899e47e9617df"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "137f0704fda1e72720b9dd98ab269233b8aaa2c4076a1271d7151871d6636286"
    sha256 cellar: :any,                 arm64_sequoia: "235095c0b845e82640ac1e574019b776dc3834aab210cfc82ef782893661f90b"
    sha256 cellar: :any,                 arm64_sonoma:  "d03ed9fb04bab0d84ed121fc02537e13801ca48f57b9bb806a09728808809e10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad79379c41e5cb30345b19d25de6b77da5770afc71b3b979af0a294ea9278d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d919f75971830a4dd22c85a8fb7d54c60d71e76bd0cadaebbc3fbcab58d0375f"
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