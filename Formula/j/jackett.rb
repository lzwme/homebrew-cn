class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2389.tar.gz"
  sha256 "a768cc1f3401b672b22e7f2eb03429c1aa2815bbf0f057da123ecbbb3382b5cb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "07ecf6df088b7d2957931ac90c2fea3f56c9e68b75b11423ba82555157fbc59f"
    sha256 cellar: :any, arm64_sequoia: "52385735814945db0e9a857017e38057e66d91761bde2987b8321cd35d8813d3"
    sha256 cellar: :any, arm64_sonoma:  "6e3f0451fa63c8f21c065854bc852acb5e7620d92d7f951d2222f63532b4981a"
    sha256 cellar: :any, sonoma:        "739eb77862560c3df825ab55f70f18dec33ace1f12a2e98ad51314cc5ebf4076"
    sha256 cellar: :any, arm64_linux:   "1b2bc81eeadf5c4748be9eca3bb8987e730e79f199e74b8943d9a995a79dc18f"
    sha256 cellar: :any, x86_64_linux:  "ba5b923c3b318db3cd2b1dd9166adb3a4cb9102e4afe817626e64706a8a17868"
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