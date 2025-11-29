class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.364.tar.gz"
  sha256 "9cad38b637bafb49fceeceeed377a08a24f589bd0e576f05f1c4ad7a8906c185"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a49cacbff34ae97f160f9fad691c2b1bf9cb4cb0fb426082d43fd1f44af3a8a"
    sha256 cellar: :any,                 arm64_sequoia: "a33f7a14720d43cedf937f62bc05669fa435c75105983c6dde39b91b688f4a9c"
    sha256 cellar: :any,                 arm64_sonoma:  "7300585b930f49e2810c7d3d713e79f6973c30ca90e581c3b0f0fd15ae777760"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4006d5f237f3d1314906415ad17618587fef26df6426bcb8f1ee0c6d6aa61a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de5b0b401623cadd138ef95b0460f4a2f5b90691630f5b72ed6f60a4d9f693b8"
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