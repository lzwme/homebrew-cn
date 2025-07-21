class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2174.tar.gz"
  sha256 "cda2451914e07c14695334b61129cbfdb90b7dd6f13294410d33210aaeb3279a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b810e7bb9661d2895fa700909655f065ad7ec566dd26f90d039f41a7f46a1cc"
    sha256 cellar: :any,                 arm64_sonoma:  "d8491bb61881dd35e396bc4fc688529ca71b4f7781fee54b41d71e70eab1a563"
    sha256 cellar: :any,                 arm64_ventura: "ef0bbfdeefa003a75b6510207acdbd46ea7689c666becb03ea2d0df9f6db961e"
    sha256 cellar: :any,                 ventura:       "06614555c37d83d4b8552fc021b66a5c57615004299dcf64e5cb07cc1c73d2c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bf852f6af2dfebbf8ce3de5b0d28cfcace6d61d600e7a2e1547c40a512a396e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7321cdb6086954316e564b1ef6ae1b0a5ad16b31283ede5511fbe76aaeffedd8"
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