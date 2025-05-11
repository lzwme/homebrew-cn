class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1887.tar.gz"
  sha256 "60f9cb232b142035720ab10b24eda5f7a7a615c1b1fc1f7c22597802e7e27eb4"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3b47bc385bd5743e99d9448fe5a7a8f11736cb872228cbb43523fb944d9b75f"
    sha256 cellar: :any,                 arm64_sonoma:  "f3b6f80fda9df8ad4f99ae46d3101ef2dbb60aad0660681406b1ab229f83229d"
    sha256 cellar: :any,                 arm64_ventura: "37d1b8cc509d1a03f34025c7449d86c4791b2791b7bab3487c05b5c3992df225"
    sha256 cellar: :any,                 ventura:       "2b4d417c633623d081aa743887044da476509bb85f7971e317ce18ce2352fb2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2224f7329b754a7694711cddbbf42f681ff34b13328ba4d7e4e7456f51f67c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fdd58cb324091b71a43b48c1ab77ea51aab2f071c5851091ebb1443d1760854"
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