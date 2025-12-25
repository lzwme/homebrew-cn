class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.521.tar.gz"
  sha256 "ebff645502fcc4c3eee8ffa4ba0701229e963ff355e9b27955039b7c36e86336"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4463f468c2ffd7bb8885c98698be29a12937818c4f175eeb20786db5297abf25"
    sha256 cellar: :any,                 arm64_sequoia: "0cd032035bf71e08c737425c1623880a3d7a7cf68820cc572b1d57bc392f132f"
    sha256 cellar: :any,                 arm64_sonoma:  "f4eac340da74a57bca23c497bf9f0f24f22f93b3c18ae3094599a2bddcd9173e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90b4659d7fd2d5320fd880682f222f11fca40e9e6687afc43d4081e5ff9bd82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbed64d54fc756ef5062dd7017e7d2a9c516ab0f574b652b4b578ffe1b65d269"
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