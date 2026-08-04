class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2323.tar.gz"
  sha256 "e98cf2bbb9e68e18a1f30de7a2f690bddeb90573fd1e738087559973e1d8f102"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "24feb713e9e16ec68b70ce6249c34983967ec9cf7f565bbb922272c4f4380c4a"
    sha256 cellar: :any, arm64_sequoia: "7f9a154693591e319aa8307314c1d81d5beb3d52425d170cc047fc00b7fa5091"
    sha256 cellar: :any, arm64_sonoma:  "a8daca40cdeefa040b06f5fceb1e9b5bfdb39248835fe027f8ddc6cb89352955"
    sha256 cellar: :any, sonoma:        "8bb17c520805bbbc32d827afe4c73f9e9190db3f5cf4aad0164efef50eeeab5c"
    sha256 cellar: :any, arm64_linux:   "db47b83474fd014b5dfa381b73f3d487792ba683714cf841c72182bba62d77b2"
    sha256 cellar: :any, x86_64_linux:  "7f522ad873c838649bff7d603d1a433b62afa5bccd049f156739caba1c8426db"
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