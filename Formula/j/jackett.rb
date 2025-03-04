class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1468.tar.gz"
  sha256 "19a3017691273a6505a2a64046e5459b97e080e7469d9cab2f246bc04e62a40e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45e24ce98b6ef2d3f9b1444aeb0e510b214e16fca2658df9459dff8cb47e3a2b"
    sha256 cellar: :any,                 arm64_sonoma:  "c0f9430cef65e447bacbc2341d394241697a4d08e7dff121ecda5e6d23449a1f"
    sha256 cellar: :any,                 arm64_ventura: "ce7af3f5ca1d1ec71c0bc32760614724c4191a9376446f1af1871bf98a9ef0a7"
    sha256 cellar: :any,                 ventura:       "57df832778bc3b54666720aad4e235836931eb6c0b72d2f05bb1289ce2b53179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "313ef660ad76bb01031c549f8b19fb548c63f69a554ad783f20c5dd679f15108"
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