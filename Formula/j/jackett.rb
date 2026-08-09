class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2353.tar.gz"
  sha256 "7d070764ed2bd80e35f3998d1d27b9f479c6a9fa58498b56b834e122ecf5974f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d6fed1d457dfa1af9b45af35a7e19dd687a5fc0da4786a0d2aa5d0dd34a1412"
    sha256 cellar: :any, arm64_sequoia: "a10a6e60d3459e14e93c4f2fbea3a0522bd19d0f4319d04512f1c3636492f920"
    sha256 cellar: :any, arm64_sonoma:  "86d12281fd7192c53e3938a3218e5af0274a35c1307c94ce5b2d60e2b758591d"
    sha256 cellar: :any, sonoma:        "e0fc7fc2beaf5f9686248ef8cba47fb35179893c0a5feccc2f01711d5d6e9ef4"
    sha256 cellar: :any, arm64_linux:   "0f75f6cdef37366e3e802b5440e2d1e36be4209e80981c1159003613a01dfd41"
    sha256 cellar: :any, x86_64_linux:  "3bb7bf09234d3779a3a58a15bc25876ceafd52a88408d6d99824d27641a7cbbe"
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