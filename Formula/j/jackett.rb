class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1205.tar.gz"
  sha256 "5b15c1e4ab5e69238da2843c3c75acf5f18ed9d948a0f0b037e94fb0b82fdbac"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c59bb14759dacb06dccb239b862e1df7f4f4c83c1bd55a4518ba5a96c08481b"
    sha256 cellar: :any,                 arm64_sequoia: "9cf6f3cb608b06ee8cc8638ac83acdbc7a4c0851f16278163cb6b5bfa782b48a"
    sha256 cellar: :any,                 arm64_sonoma:  "9a426e25e6da3812d71b58d27fab2e974baa8e42869802a9b361a7e1f5c88c01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9ccdb63f2390da2e2ae67f79689177cdb5e97e759451f9df07234858a902b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d79c30c2e980eb5dfbc746cc4be485fb0d9fcb26f50842b58ff5c0dcaaf18d"
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