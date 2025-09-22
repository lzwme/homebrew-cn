class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.48.tar.gz"
  sha256 "61e76027dff5277ce2670aa92881939c6863f2de70413462f5cdaa84eabd0efd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04557939860768c21ec830e287ff43bf683f4c5e7f3da02a6e7b7d28b3baf9e2"
    sha256 cellar: :any,                 arm64_sequoia: "302e599c480934cb0bb326b9c41f669c4b08dd56a8a6c76773ced197b8d22342"
    sha256 cellar: :any,                 arm64_sonoma:  "8b6e60f007e74bbecebc5251741f6c42e8157cff29b41d4a788dc2ba51facf3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d05435d487b57ea1ee6115a1e0b0b6d459cbf8b07031812a28a9cc027c708b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d104b7bc5c23a2c541cee382144db4f1167004d394c325b39e93394dda80e8a4"
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