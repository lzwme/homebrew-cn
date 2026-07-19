class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2233.tar.gz"
  sha256 "1ea9a926c9ddc2ecbb6927c93d81057cc7c973f61da60142e0668efc1b294afa"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2e4f65b3be2a825a02045c680828434ac73088fc7ad1ecf2705f300b3cd4baf6"
    sha256 cellar: :any, arm64_sequoia: "82a6c72a50c1ff012b66563f963efbc67529964f7112065fc63862d3a01eee78"
    sha256 cellar: :any, arm64_sonoma:  "64f7668178ed9889863eced9cd8cfcd5175ae545f31c2774fc29e2799667f904"
    sha256 cellar: :any, sonoma:        "dbbf18f9c2d45feb234ec7764284b6449aa240471fd63cafac85ede92d210740"
    sha256 cellar: :any, arm64_linux:   "bccd838c6e977dd6c86a7aabba5e7e479d5a5191f4e42c6f8d6f1bd94887e97f"
    sha256 cellar: :any, x86_64_linux:  "0f3d2e24338c7524e235825dcadf5722139f8669837ccec870e8160adede3261"
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