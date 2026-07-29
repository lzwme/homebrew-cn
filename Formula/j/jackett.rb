class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2288.tar.gz"
  sha256 "8a3e3d8e4e679dfc7c71caf2e4acb0a033bf6001123eba7d7456e75b566de9c6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3c83bcfb30ce9bffcc53137b87179aed046c4d2147b930939b8640291f85f33c"
    sha256 cellar: :any, arm64_sequoia: "8580db4c696784c72d8cd8863b41de99bc3379df98ed04ada581b43bc6567e3f"
    sha256 cellar: :any, arm64_sonoma:  "934f5b13cb497d2af785a87449d472c255bcdd5ed5ef75be1397a309bc22eaeb"
    sha256 cellar: :any, sonoma:        "a7d4373ea354403e75ca178945e06f03bfc078a8baed456bc74bac73518ec57a"
    sha256 cellar: :any, arm64_linux:   "aa3aa6fba791fce3944018770b3bbde8dc27aa105654ea995d7903a85c76b4bd"
    sha256 cellar: :any, x86_64_linux:  "eb7444e8e68c4757ed5b82f189a40568b4a48afff6502450347b004dcc833f8c"
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