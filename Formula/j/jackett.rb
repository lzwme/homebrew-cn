class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2419.tar.gz"
  sha256 "e34e37f0458e18bc99c87ad5d50eb9abbaec325037404fc36ffbb8a5bfd5ee56"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "df3a6467b1dfb63909aef2312dbcda7ca8bb5d72406350aaa0ffec608b3f967e"
    sha256 cellar: :any, arm64_sequoia: "a75d0b0aa0d05a268d7e140b990cd93dd0e1e85f17cc5939354e553226b15dd5"
    sha256 cellar: :any, arm64_sonoma:  "bec6464a3b014ecedb9048c3fd2eaf7a13d58276ba7e75c93764f5916e436c5b"
    sha256 cellar: :any, sonoma:        "a9014a195de92e2edbb277f1257a28e7215e9064b3b2881fbb227179b1d5dc65"
    sha256 cellar: :any, arm64_linux:   "187bc2474fd7ef7b2692def4a9076ea661f5b9c33eb8625794861209331a9fa5"
    sha256 cellar: :any, x86_64_linux:  "c85e3ed6f2e59612ce9efcb7bc2f4679896d2671d5965d7b8eeaad392f0aa3c9"
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