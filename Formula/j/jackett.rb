class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.903.tar.gz"
  sha256 "344ae1f09641efa9c226b69c4e80e73ef420f3fca6e58b59d00aab2e521ccc23"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1820bc7822f274a878d7b55de47c6007f9aa2a4a5742eaf54dc26c45a918ce7"
    sha256 cellar: :any,                 arm64_sequoia: "0f84920840104c785fdce801455d814e9e9eeb10a0e0d79825e4c2e94d240f1e"
    sha256 cellar: :any,                 arm64_sonoma:  "77e3938b3c06df1b089f01632ca1bb1f8c79a067d510fdcc6acfeaa3e89869ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ce19a38950de05b560fbdecd1accc9d56d35cd060376fc540247e1af9808569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "655828fe4a21f85012aba812d177b465b486ce5cb22f3bad09034cee417f2670"
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