class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.131.tar.gz"
  sha256 "6fd0a3ab816dd9a3a698ff679d3a6af77233b9c8e2575fd4cc169f36603a1351"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0055c01ecfe649c9254b9a23ca42d9e84ca59d3d1c34f1577d32cb0cd9e82c8"
    sha256 cellar: :any,                 arm64_sequoia: "91b11a071db59a8b2e312af6ccc2f99c3e47f3a6508cc71abde673f035a9c8b0"
    sha256 cellar: :any,                 arm64_sonoma:  "8db3350d61f8d06283e5512a7cfca0b2a42fd6049892b54b9021aff9e3e3c5cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9215c6c0f46fff7f5c86aac140c4e1164099d689f8916a962a9c12dc3eaaab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c08853968ee3099373162773226e3806a510f990c50665a9afc9fd64350db04"
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