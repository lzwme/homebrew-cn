class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2248.tar.gz"
  sha256 "4a2d232bab3c5c1966e13c4d30281d46b06e5e8c01fa4dc7a91bdfa84848c705"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "83800ba93ea5386a6218bc662ae92b4f9de0af2406231bcf80c6441008c7f761"
    sha256 cellar: :any,                 arm64_sonoma:  "53dba027bf728819bc190f2f06574c0a90a910412ba113e9198cb0a93f1a6243"
    sha256 cellar: :any,                 arm64_ventura: "3d6fcb712bd75332a5e0e832f1c66d21bfa67bbbb5e009f47b7abd3355fee591"
    sha256 cellar: :any,                 ventura:       "5766d0b322cf786480abbe1033fcfc9f2ec348d603f29abbe2e2a9bb451749e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33525b21b2b328f5fd6094feabfe86dee7581aeb35498f4beb2d390e62524022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00af87a4143afbf761a671b022a01586e2e0469c8b9308199ecdd3411699c892"
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