class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1278.tar.gz"
  sha256 "0a8a5fe14b7a8f6e0b23d23b576f72120e3970781b50e59a5b50fa5cfdc854e9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c791d1aee6d99adb767599e7e3e4e76ddfa6ea3e8f25ac23a314c58b03be0a11"
    sha256 cellar: :any,                 arm64_sequoia: "5d9ead46a54e77533c445a6ef9a20ede5027db7239cba943934d4ea75cc9fbec"
    sha256 cellar: :any,                 arm64_sonoma:  "2fd16d50195e579316748533f5fedc5c68fc53909c4e1af7c3272a85643ac44d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f373aae0165f8ece93d262d61f1f2943e30eb5081209364c45a8ae9aa28325de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df975ed4fc73f4f04e47c45f7eaef33b3a5263768246629b7d5d04cbb313dfdd"
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