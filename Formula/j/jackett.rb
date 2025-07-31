class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2208.tar.gz"
  sha256 "43ac6501aad25ad1c473576f388ff916adf75be07efeeb81f79dab45aaaf3281"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "227a34366de149f92738e4a697e84da4f2a151cae9a3c2ef93aba0aae539881c"
    sha256 cellar: :any,                 arm64_sonoma:  "d1c17cc50b8e922f55a180497db4e52dc04034f439e9af47031254c575eed901"
    sha256 cellar: :any,                 arm64_ventura: "f00840f5f268e723c103046cf5e0aec902ac2540a5f606febeb48b3463dc161e"
    sha256 cellar: :any,                 ventura:       "54a960561d3949d623cc41fa36262c0e4dea196b8eca9efa66ba3960e2a8df86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c5a8aa69d911bd2edfc74045defe35b2afc281ee096ce436b6b0effde6e6ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc2887138424e9d1f08e6b810f68489ee4eef930eb6256f117b452b75749dd9"
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