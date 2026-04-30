class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1795.tar.gz"
  sha256 "ed7e5f212517b8b85e7308f7d082316061ef85cd900644c3e687c784d1023e33"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8173053d0f3a478c961903695d4ea80ed2be7f45c58fe1d42c583005e3d9d1ca"
    sha256 cellar: :any,                 arm64_sequoia: "de8a256b17c81dc24dd4c7954e1e30c66a7c2d15a3fedfd2871df98fed3b8599"
    sha256 cellar: :any,                 arm64_sonoma:  "11f04da85ff6e0589a9b50f7bf119f4c8b80d863f9f236aa2fffad539059ad67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "638246fe3a3e35f58462932a453d46a765f380056ec6264b0fceb23c7c3a53d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d170f8507299273cc9c2f4e10dca035db093cb33c90866631ddb765d5fc59002"
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