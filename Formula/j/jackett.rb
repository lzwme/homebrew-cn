class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1632.tar.gz"
  sha256 "01985c9d3b0b0a6b15355547d9b972f5562c5c778499fdbd65496647f3c7f26c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87a05fe5615e0662f16a662340a00489d81164aeb05d41bb0e5aaab4a7d30f95"
    sha256 cellar: :any,                 arm64_sequoia: "a06cf0a0a514df3ecbd4379e86cb1716bbf34f4c7eab1c656bbf92a12a01cce1"
    sha256 cellar: :any,                 arm64_sonoma:  "8f9ecda5de6b1b670e1c88012dadcb4c6428396503d978f46a2567749b12449b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f687b8966871dfbe02eb02239c5f85b6f05a1f22085877c4a306c845b77c0105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68ce6fa7b43bf18de5b1234286d2250888ff46fbeb7d52ed9c6731e3c9be9ed5"
  end

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