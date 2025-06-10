class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2002.tar.gz"
  sha256 "1d5359a376e079a636d88298ac1133e90bb991642eb0a83a4a88f4660bd93db8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5311504663cb934b4bb38e5b685cf79def11f1fcda48a58898d756bf6c0f4724"
    sha256 cellar: :any,                 arm64_sonoma:  "63e4120f1ae981f60fc00fa93f19ae360946cde7449bbf31ac2bb84d914942e0"
    sha256 cellar: :any,                 arm64_ventura: "8d22d9262af178cc057c6fa2522f3b27fa45d235436f4d88cf5b74864995ab13"
    sha256 cellar: :any,                 ventura:       "6dd027a613f7da2051959cf7dc669fefb3c93fcca2d526e69c14427f30bacc4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2435da10f14d0f9881578872c860c2ffb9b587d114455ad1d32a1e43b6d6d0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6450163be753fb76bc7a7d542da7afda51620effcc7cbd557e2fbe9d6a360e7a"
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