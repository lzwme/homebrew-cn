class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1601.tar.gz"
  sha256 "db6bf9dae346a9c6dbb3db6ee997ce24ad40c05a330aad598b0829a5feb0ba08"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fcf067981181e0eb9bada56202a65c8b5bb7b21bc3e569799b41d8542aeef262"
    sha256 cellar: :any,                 arm64_sequoia: "b3aac5b5ce7b42f1e2074e37853446491cc8db610341757497c9d846b5410ab5"
    sha256 cellar: :any,                 arm64_sonoma:  "afb3afe549b89ac2b245fb938f3ec716e51a3cebca8df211da34ab18447c0f97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eb48576af7b7cd63a02ddcc2263fd74c5469bf1d1dc996dde91ff810837aaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6188ed0b17246c835f5ccf3e8179717c635216bc973fb51332cf5d79538a7d20"
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