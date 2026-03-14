class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1356.tar.gz"
  sha256 "36cd9fd31eafaaa9afad3e1ccdc68703b7a4e11f05d18f9c69e6196604e5fcfe"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "344e92e3af80d78b2f7e6e692ed05665f646ef9f138bd35867b0a88817e534a5"
    sha256 cellar: :any,                 arm64_sequoia: "03329c292d7ed0451596521a759eba53c678556000537e0f0b6822418d6ea92b"
    sha256 cellar: :any,                 arm64_sonoma:  "9b9ac0b23305704d84a594b3e018815197085ad791bd21b431ee5d924a464898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4d1f1bc908105cb27e80c8ea5f72be6f392056bc00aee88930f06d5d3e3fbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d9c968aab140771c74df8eda1dc56615dced39e8c1a9fdbcc675d541cbb7790"
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