class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2158.tar.gz"
  sha256 "79412fdf7fc2c02b9e06176d56bad98b8c63685f31402b8918b5996900671f0f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "33cfc3ab0ccb3596ee548089fb96696c7fc43b610cceea9f8ae5d32187794439"
    sha256 cellar: :any, arm64_sequoia: "cc2b075af73af5afd187172ef6fa9785d802ffa51586cb2597912e33bf72a74f"
    sha256 cellar: :any, arm64_sonoma:  "879e1ab12aca0b9003e845949e40e8f3c9a428584d72c16124b4c8a8d4da4e62"
    sha256 cellar: :any, sonoma:        "5695a52cccaaa85e4191d978500ad8be1cc642b8cb3bdb7eb416bdece44d0d8d"
    sha256 cellar: :any, arm64_linux:   "e692b161ce220e3535217330621108746d81c151cc67b78ebf8ac047b4c6cdcb"
    sha256 cellar: :any, x86_64_linux:  "29926aff58c2bb82a2bcec319de8715c3b4b22b9a5e71d9312c97e91b0108b06"
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