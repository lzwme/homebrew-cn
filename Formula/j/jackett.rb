class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2416.tar.gz"
  sha256 "2923590a17e9345da30916d6c27da78c60873f15027f253821c7d38938f9ae23"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "56b0ad40023bb83f2967dde5519eb33b68c8d006a7491e56779631db5999ec48"
    sha256 cellar: :any, arm64_sequoia: "79998100945b8b3a9a3aa881b7bb962cbd608b354fa8a31ae55889bfb89a089c"
    sha256 cellar: :any, arm64_sonoma:  "efbdbd059f8a7c08f431ba5b68f86539e1a96aa082d76005e7ba2c501f501485"
    sha256 cellar: :any, sonoma:        "83aceeb40e39cfd48dcf8b35ed2a9f575e57fabdf76f0e1a6fc706952be5d6ee"
    sha256 cellar: :any, arm64_linux:   "0c4c20a9078ec0a4a2abec8a25d59fa83a00f035ed7eb070800583a676ac8c1c"
    sha256 cellar: :any, x86_64_linux:  "b0edbb9f6146d99bdacd7fee5486943fa3e4735adf93957b85039e0f61f13ddd"
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