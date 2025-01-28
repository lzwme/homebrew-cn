class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1316.tar.gz"
  sha256 "f878337ffb7813b714dc641b43617623c860b1bc5944b9cbd1d800c7d5f5de0b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6f55540092143562347c8257d7c1f51d3a95e619458386e8cf40b2edb8055ba"
    sha256 cellar: :any,                 arm64_sonoma:  "52037577dd6b02f7399b1b31bc278a869369128496619b4c0ab7d8e35f8790d7"
    sha256 cellar: :any,                 arm64_ventura: "e48e1114844a4ae8b6d32f63be04b7b9d08f1ba2754d5c97b2158b87243e9e60"
    sha256 cellar: :any,                 ventura:       "4c1a36c540e5b626dfe08b3d70f226840f24770f973ee996a875196497ee7f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e852c82501ae2ad94acabfa98c4d8a744a247c236cf8e7a6d5271a2d2b01f3b"
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