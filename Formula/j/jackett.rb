class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2117.tar.gz"
  sha256 "ed9ce8222bf715eea14b7a8fe7d348aea4b90543426328989d6cefd6caad5d8b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "322af214a87fcb2e901637633d26f47d4f39875b4fc93255dc2818b1a6a4bec8"
    sha256 cellar: :any,                 arm64_sonoma:  "9a64c9ef0ebd8b5562bd463b8584eacd1a1892ca895d332201e467703ec9a1cb"
    sha256 cellar: :any,                 arm64_ventura: "4bd144b455ec1de27fd497f81c2e2b29a26e567a4bda5377fb1b104b9ed7de06"
    sha256 cellar: :any,                 ventura:       "eff6cafc49315502176f9ad802a931bfbf244cdc624bdab802677b26a50236a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba331bf19e71cef584c75ef283edff18ba4323c188b3f5d6629d64e1797a0951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d8d8bccf93b11faf7b5cbdf875046d293c00fbad2c0d67de52a8ef2ede5c8a0"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

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

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end