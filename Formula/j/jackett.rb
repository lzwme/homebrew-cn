class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2043.tar.gz"
  sha256 "c11c14c16d5d55cf425546bfe0bf6fab42c5be6f8224cec60b80532233ee7c2b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "35f665591194a5c4aef26d0580bf4cd895005b458218161721c2ee034afbe146"
    sha256 cellar: :any, arm64_sequoia: "cad4027222e1044760edb62e0a7a7e3c67bab31c80c0c0155ed6f94119325a8d"
    sha256 cellar: :any, arm64_sonoma:  "e5135d3a7fe16cf060c384d954fe31aaf5e23fb00201fe7da109638d0249d5c6"
    sha256 cellar: :any, sonoma:        "1606d81f04df064193f20488bdd9c7babd260b466461c0cbc4a896b7534393d1"
    sha256 cellar: :any, arm64_linux:   "6750ee9fb6162c4d3fbec2f97fe0e7295b0c3245559578569400a61e465fc7ca"
    sha256 cellar: :any, x86_64_linux:  "bfa2c5d037d3392ba8162d25b62ffb2d65c96cc463ade10ad6f262f777f18b01"
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