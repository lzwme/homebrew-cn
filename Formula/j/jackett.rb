class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1226.tar.gz"
  sha256 "67dd2ebd859805bb45641bb19d80f35365cb0ba8e785980cfb4b4a479d5f1c87"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8b8b0235a552fb99d9d1b10fc70bcc1fe2c768cc86f88a6f29f27744fe34364"
    sha256 cellar: :any,                 arm64_sonoma:  "d95489fc80621bb0b69f2cb5127ea974ba7a8bf0bb021e2bf2ffd99e3a4d46d4"
    sha256 cellar: :any,                 arm64_ventura: "c80585f57c9251142e73f84493164137fc654b669b32a88702f3220a390d0a63"
    sha256 cellar: :any,                 ventura:       "4513ccf26e5fbd46dcec1df37d2439b82e4f6c9c8ef03a5c30b6a685e4d7315f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf2ddf4e96f12c387696c45e5d883d7e5abf21e89b2355990cd8a07e73f5de16"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end