class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2033.tar.gz"
  sha256 "0e041f9e91515a79cda6aa707badcffced82455a084a64e4d62eadb84fdac1fa"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e691a9d6993410668cec0ec6fb069d43ee66c90bca1851ceaaf295e74ae8fc0d"
    sha256 cellar: :any, arm64_sequoia: "57b648e72c7d3b3fcd2f69e40816f081d607b0fe9b74898e76de065388025db8"
    sha256 cellar: :any, arm64_sonoma:  "b0226780cdc5a0d35df81f04a87abd6e5a3543d630fff5eaad48e004543d612f"
    sha256 cellar: :any, sonoma:        "7634afc778252f6483ebd46bdb3887dee01d30bafeb5e320dc3c72aa14a35ede"
    sha256 cellar: :any, arm64_linux:   "25088672aa3eaa79e5c4a2a56d9a941844a14c1b58ab3d0f25fad87b7bb58cdf"
    sha256 cellar: :any, x86_64_linux:  "9db8d59fbec41a79c03c72922ae046fc4e5a91fb879f94de73b44275cbb21fde"
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