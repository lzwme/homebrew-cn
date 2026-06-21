class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2092.tar.gz"
  sha256 "a7b1dd07e19c20c30fc1e26f01aef7b0e22a40fbab518b0e5ef796f8d737e94e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ecae21c56e5b0a908241c7e3618d4ddec05f3d6a4b2977edd22800d8137fb472"
    sha256 cellar: :any, arm64_sequoia: "1f596411ca2852906bcda9ad4a6ef855d7802433f64185cbea7c677ebfabf76c"
    sha256 cellar: :any, arm64_sonoma:  "8ffc654150e195b01a974e0c47339ac7f0c1f190c959a9c74ff85c775807c357"
    sha256 cellar: :any, sonoma:        "82411928e7124526d7c53c896e9a14b8b740171c4663c9d9dc65e414704ebc10"
    sha256 cellar: :any, arm64_linux:   "aa8d2e77680b2d46a906d05fc17055d3808d849e05e89a0263c9845c0f1d4369"
    sha256 cellar: :any, x86_64_linux:  "7b5572911bc83b03884da1f1c864e1080c47ef38a3b8a6550adae1be58230888"
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