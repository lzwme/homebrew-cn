class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1323.tar.gz"
  sha256 "921b6008db29dc5717ca82bdb7707e836507ba82d4a2b60932ed2f2ff55932d3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "44467d0133f14a2c280e0e1f9ff2d7ab06fb072d198fc095d3769bf33928f3ff"
    sha256 cellar: :any,                 arm64_sonoma:  "a595222087ed5d66c0835f2b96c7d31682c7ab9e4852f54022fff0c1ca9e377f"
    sha256 cellar: :any,                 arm64_ventura: "2769bd29ee3fc58d4d71c367a3de901b7d6abe621df0d8b2af03ec9129ebc0b5"
    sha256 cellar: :any,                 ventura:       "ac745bcc22d2a065f9f78235aa1fdd479c56646dcde4f3e1b1e932f83a60a32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d74abb48f768f1fc43c202ce7976c3792245634de896792913f902dc3dc623e"
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