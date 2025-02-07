class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1377.tar.gz"
  sha256 "ea86429709b22cc0a4a2f85ad67531dc98a665b7a7d32c4a8b95f2f9b23ef2d1"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "88685a41903f964c10f2a22fe844e2e8ef8c5fce99002aeedb772bec85ec74fe"
    sha256 cellar: :any,                 arm64_sonoma:  "0d62cc54555c389965e856012ca83bb3717dfff09a1530f887226c15cd16249b"
    sha256 cellar: :any,                 arm64_ventura: "2e02c15f6ae981b045421d2bd0169e1aebbb652224f7089c3a05666fa9834796"
    sha256 cellar: :any,                 ventura:       "a3b8fc815e7e9fad6e892af01b42d0fa5d91379629348134969a8bae29025650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f339ee9ea6df324b75fc71656148137fba49678fe8d95fe783fbcf8b64ccd51"
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