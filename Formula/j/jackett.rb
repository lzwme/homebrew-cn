class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1564.tar.gz"
  sha256 "1a7123b2713860e0b7c238c7c991fc15733bc8e0388a5bde5b54b22879896fd9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db0f2fa30e612c8a6f7bb61747a47bc081cb7a9d4434cd73b9e2021cab755fff"
    sha256 cellar: :any,                 arm64_sequoia: "c32016605b103f823ec5114a9ae01bfd3d2b822a5ae4bffd040b68684d780694"
    sha256 cellar: :any,                 arm64_sonoma:  "3a36e9adce95f6d640529f046a82622ac1f95654eae924183854a4cfbd2f0b50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dc1aa63b3cf1c950a4f4ff10e57af7f014deab57b30e33b38962625ec9b6844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da71a92e351aa2faeda8181199b6926912a3213ae50dd0219697b9b30f3e8584"
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