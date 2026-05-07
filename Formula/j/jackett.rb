class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1816.tar.gz"
  sha256 "aaa498c916b944395202bf3e0049152e4f294c15b43cff8cfa3c52a9f8edb1c7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42bd19366324f8c20b6c45bc9f4f2591948dd1e11b56ad97070c2c0ccf92f214"
    sha256 cellar: :any,                 arm64_sequoia: "a80109865c9d0edce11eec7f50da8f7c4e96d811cff73af561f63194e8805d4c"
    sha256 cellar: :any,                 arm64_sonoma:  "83a3d603c26defc590d71c6f1c07c1d0eac5507e29348657a24214db84673b4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d02d9758926cecad758e853e7317cb21c9f125f6b857e2facf39805d90d2a5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14c614925855fe56276294c401e8707f83f61205be1abb701d4378f3b0f06920"
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