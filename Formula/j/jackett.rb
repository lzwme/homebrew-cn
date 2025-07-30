class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2207.tar.gz"
  sha256 "4e94070071fd7b6fc6dd22841fd52256732e7da57c84900e1591b41c1ec6ba9f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4dc2594e3f8656edc41ba2f8e15ac68459ac0433771a969a6d8431631c7fba6d"
    sha256 cellar: :any,                 arm64_sonoma:  "8b1a9858cbedd624ae1e68daace1f00c5c1691e27c3549f27bcc098ce5887c99"
    sha256 cellar: :any,                 arm64_ventura: "6b3ef030bdb8c30cc31a0bbb79b8d277a138bc914137f07d6a008cf724b83f23"
    sha256 cellar: :any,                 ventura:       "d44c85e3d96ba8bdfcd12a96298a21a7560b3715285f0e864cb18d9310fc5f03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da73dd71fdf2a9cb5f6685c57e6e9e6c9feef4acc5f6c6fe7e787844d87e0db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "387217476fe3a29bf544ced9e5afbbe40c60f84e26b685a62f32b976caff2ed6"
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