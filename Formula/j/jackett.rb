class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2342.tar.gz"
  sha256 "cd40bcdade3cd282fee4e699709025fa0b9ef6f4160ecae91835c09471e7110d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "75d70ed6e120457e4ce6f2c44a1388e25dd79bb62e503684d25ef923839cf1d3"
    sha256 cellar: :any, arm64_sequoia: "16660720456ff98b7df2d82819121ad6b3d987cbcdd42647600ff25d468ae1b4"
    sha256 cellar: :any, arm64_sonoma:  "3a833adf76195e7abd705314be533975673c5687cb658dc6c140340848c7333f"
    sha256 cellar: :any, sonoma:        "a771e2217ce4d3c24edb860543015308639c0cdd1aa2a1dc46d8a598d41b7562"
    sha256 cellar: :any, arm64_linux:   "adf5286a1877ba79c36ce0a4821f27fd1ebd18feaf49cf7145b1ecc199db4813"
    sha256 cellar: :any, x86_64_linux:  "9bcfa4f7575a4c834d91bad7e33f5dbef9f8a1845f0199c9793efe6c811cc049"
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