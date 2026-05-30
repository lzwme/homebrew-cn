class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1970.tar.gz"
  sha256 "9badcea6e7471aa81803f632ac1aad980304784ffa393359632bd62a2e4e5cf7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "58549c239d0dbab29a5c3bd12e100249b32064173282fb3e4b48474d9ad8d035"
    sha256 cellar: :any,                 arm64_sequoia: "964b6482b57b6072a0066bda2244924bf9aa3131a28fea28690414fa2babd877"
    sha256 cellar: :any,                 arm64_sonoma:  "f8f2f46a5bd126d2451e940b983cfca0c5672d4c7ae86d811f6fbab9d3a7e90b"
    sha256 cellar: :any,                 sonoma:        "060102cb18aba45384622feec6356d3a43f4948d65c74fda03c447312605e000"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4afe524ff1a56c183a3d2541598446f111d2f1c3fc791ba49f6ccc438e00edfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "784f8133c0ea30e9602c3ab8789ff3f67d297c1da75d02d198fd2806b5dd2367"
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