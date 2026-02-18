class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1140.tar.gz"
  sha256 "f3eaaa996c7263c5e8a295c87f7ddc8a134a43b0870646078911a4f85b90504f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9211f42377361f070e47f69e684aa5f25f3436facb1bf64e75e3f7cdf594e856"
    sha256 cellar: :any,                 arm64_sequoia: "ca165314ade66c831e9c9d529deb5bd77d8d1a6dfa6a2046221ae8b206862d73"
    sha256 cellar: :any,                 arm64_sonoma:  "42d7f67cb9cdd84198a1ff8cb294ce7d4aa8a4073bc93280d426de4a8c922d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c72446bf79ef8d9d8ae406ac2cfb1f7dde2966f0d821e8946bb6422a9ff774f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea7d192998adf67d32c04b1d426d1ece39bf5476da216ef8553aa64e924d8aac"
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