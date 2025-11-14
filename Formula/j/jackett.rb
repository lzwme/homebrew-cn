class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.301.tar.gz"
  sha256 "a817f6904f993bea663f020982965ca96595ba19ccf2ca565f6b001550b4af31"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "570281df6c3d45cbcfde97d17df6aa280294356cee0021a61894a20a52c2abe9"
    sha256 cellar: :any,                 arm64_sequoia: "2fd34264cf8493ee71119a9f099a0d7a0065f83a7a59c580013732839637b092"
    sha256 cellar: :any,                 arm64_sonoma:  "181723d5a16ce13c87991afb0952056879ab11e840c7fb7da41c8be9189fd22a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ffba46e32890500514f0c74e3d23267d876faaf17425d2c9be5ee7318333f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "039d0365b72d30a3b23dbc5b3dbcb8e7a63ac21c10a15c7107efe60e5f7fd16e"
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