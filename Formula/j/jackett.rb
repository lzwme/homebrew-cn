class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2142.tar.gz"
  sha256 "ee0cb9f867418b57b8502e1161e50ab0e30fc83f9fb6decec6c1d625285daa22"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "700692fb4e4a12000a5f61d48b7d5d7a5da43ccec896068e20c2781804b27446"
    sha256 cellar: :any, arm64_sequoia: "092f2e71136914a1af358edeb777529743c6c190c5d2f71a967aa8c14fca2972"
    sha256 cellar: :any, arm64_sonoma:  "21a9edc176356379b0266b862e624f1e880c568c3d615036ac863a8ab0981bec"
    sha256 cellar: :any, sonoma:        "30a223a18b8e56dc90804f3f377f32eb13d85da0bf557a9a6b7ea28e39e4efd4"
    sha256 cellar: :any, arm64_linux:   "145d359391a52d057ffceab3a920ebb2a662cebfa0e72670278f3d46f947c634"
    sha256 cellar: :any, x86_64_linux:  "d8e16374ccfacd3cf0fef753dd5d75bea0a25b95b3a93cb9302bbafa15198873"
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