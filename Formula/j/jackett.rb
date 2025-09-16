class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.23.tar.gz"
  sha256 "84111d121e2deff7001102c36fbde9bf56e656334bcdcf3286ecc0a007c5e8a8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42682aec267c5563863a835c23ba50fa25dccb4dda203e1bb43ebd71c9761168"
    sha256 cellar: :any,                 arm64_sequoia: "527f6ef53f2a6a2d28f6e1b8bb4e12dfb4efa0d0c8be0be525c7efbfbbbe00c1"
    sha256 cellar: :any,                 arm64_sonoma:  "c90d534a2b818a96cc29267b719a5f63808900608b3446bb95cdaac69269cd25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f258514de829b6bc1fb1d661b70b3dc0d010c4e84c4d01712dc6802ead9552af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c55f083e4367abc6e4d2bf3e00dc82a873cd444fd063312528360dd57d79bec8"
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