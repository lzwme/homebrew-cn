class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2057.tar.gz"
  sha256 "1c3ccc920e04814225c330ee7eb2daf03a361c2f2e85b4b366e3b04f4f93f358"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "40bc8d0b70e1a32428ca5e5e52f47f3f00f945b8be97c002f8a9b29c8b6efb44"
    sha256 cellar: :any, arm64_sequoia: "221b5ea81884e30f8dd5562dd86140bd187ac4561ff10dfb0ec5d3598c10962c"
    sha256 cellar: :any, arm64_sonoma:  "f624a9c35098d4c988d730f679585cc80ec5efc97435ff959f0826baad48569d"
    sha256 cellar: :any, sonoma:        "adcc85620d91a07772e5244f6bf786935fb9e9da55ab2761e8f034daa6322823"
    sha256 cellar: :any, arm64_linux:   "8d183155916e075f1f865ee9758ecf44855b2357dc8384f0f2a9f5cef257cf19"
    sha256 cellar: :any, x86_64_linux:  "da9d96f6795748137df1a1d8efa8ca53edd009e4652b3daa8b183d32d4a553c6"
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