class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2475.tar.gz"
  sha256 "efaa121282e9d4ec48188746c525d2b600ed547d0c0262bb032db50c87bf43ec"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1f41aab970d813b0eb51b41dd8118468bf44fbe841263e72e49a87efe898fd09"
    sha256 cellar: :any, arm64_sequoia: "5b14e05b6c533c8ca6bfb962bdad74cbd6d8c9f3573a72b9fa129955635bb376"
    sha256 cellar: :any, arm64_sonoma:  "6b3d0802464e8f099ec777d4c4d96b20e9fd9ea4c826d12adfe5f4152710ec55"
    sha256 cellar: :any, sonoma:        "85d959d1059ec7f47351a32acf2570bf1ec3a0885595a83a33c2b937c50f4729"
    sha256 cellar: :any, arm64_linux:   "ff1de2011c9929b4cc9e0b2f48c73e921506b8fdf01d2d3cce8b8d8421f0b1aa"
    sha256 cellar: :any, x86_64_linux:  "96750589a16ab7e54fb377eb2f61a480b76ac24ff4e33cd8f1659e2a8d754bb2"
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