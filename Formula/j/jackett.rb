class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1470.tar.gz"
  sha256 "5f3f3c26a3fac4629c55b82184f629e0fdc8a0043a22366d28790278592e28e8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0d011a364a11ad3cf065369b1337e7f1376d9a7ac941b33a35b006e0638dcf7"
    sha256 cellar: :any,                 arm64_sequoia: "d5088c16f1c475cd815556e3294852d9b6d914c7340ed2e8e45f3d1a0a6b95db"
    sha256 cellar: :any,                 arm64_sonoma:  "a47bbcebedc7c2f22bb3739e0f3de53a4b5e195f455a5cb78b283d8c6a5c47c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e5acf94cb7d63ff590fff5b1c7183316bee5f5325187880edf9768613310d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d576127f839a8ab0a0e26aa14143f7b250871f44230b7576ebdf82f02808898"
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