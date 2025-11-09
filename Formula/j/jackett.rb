class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.262.tar.gz"
  sha256 "444d24d3630689f42aa6ecb9e0396c388600cb82c25c1da3d321c286eed62d22"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0e213817179c7344da10d432802792a457bde5b7d96332cf5de0ce9e13e3645"
    sha256 cellar: :any,                 arm64_sequoia: "6ebd44da556004ed7b45725464bb077b7a57f2d98b90b30d25e8e4433778b597"
    sha256 cellar: :any,                 arm64_sonoma:  "e29b9be7e9c171be02bdf551d1fd7a52a721d1ced72779f4ba0f059ff9549634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad66be5c1523dec3b984c537381daee4eca9738328e6d40b4edcdbcae599fd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a95f4d00c33dc048dee3382902f9fb2d4e3ed06a2978473375601f744392534"
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