class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1229.tar.gz"
  sha256 "3705aacc3786e8b4981c8bcac952920f79145ad454049c2b1970e5b900855c41"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "706ef92c7e16b3a8fcff3bd49898ddcf3a8bd80648ed98bfc23c4d541161ce0f"
    sha256 cellar: :any,                 arm64_sonoma:  "8849449788afc238106b20b235930afdd41714585967844197a16f37d1f8c383"
    sha256 cellar: :any,                 arm64_ventura: "0d162d6a5759ce51c17deb7ce3661c72bc5639d49662a2dbf8368c127b2f9653"
    sha256 cellar: :any,                 ventura:       "ac3242680e4c737405169d68a4fb0855634b3f5057efdbdfc5cdbb84a35c8fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b292835b6ea8ea487154db3288b292373966472e9d866ccdab561c98de2dec85"
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