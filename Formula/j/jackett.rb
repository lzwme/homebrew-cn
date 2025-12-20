class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.487.tar.gz"
  sha256 "fa5d39dcdcf275988ac200dc831ca71fa0e033a2a1b8b19875af9b2c8045fffe"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e1c91342d4ce422730a4baede7d7e6751b86b8ec1cf50cd8394359abffc81793"
    sha256 cellar: :any,                 arm64_sequoia: "5d93f1cecf450a63b952b5ff46dafecca2d008a7aea49f7da77d8c09abf4b3be"
    sha256 cellar: :any,                 arm64_sonoma:  "fc86a7114ea9e2b047e4051f053d696f5d4899ef6d25b287a14c8efeded72e94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e11faa0dfac2768368708a58eb0fa97b2ea496a6c443fadf744139ddab8032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "850c6594502575f4813260522bc33b6e5f04327c2dc555bdf9f9e7d7726ac17a"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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