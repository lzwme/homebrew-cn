class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.831.tar.gz"
  sha256 "0b3536282edde55e440869bb22fe44d25106f727aeceef54339c15b6379220c2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8739b0f1e8a574172055b28461c6178ff04bb79bdebba98d3cfa8e3517e879a"
    sha256 cellar: :any,                 arm64_sequoia: "c876afae56f837329485357300a3ec22cf0dc0a1eae0919a8fb9e123ef302b86"
    sha256 cellar: :any,                 arm64_sonoma:  "a4a654a933ac1ea428372c97364f75f3b0d6bff4d4de35b98237cdb4f9c2ad75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a64c4d3d9e186be54548658af38e14ff7b335fec1eadeea7b4443244420de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca889c5bebd1c2bebf3b312101ca957cf1852c9b8410d94ee96008446616638"
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