class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1462.tar.gz"
  sha256 "e6e6b6b70662e702c5851748a8947a930b592019b520da6f19f4f25554420243"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "02c04223925de64e90bf7bcaba191e254510e61f265d8efae81dc578bf696e7e"
    sha256 cellar: :any,                 arm64_sonoma:  "72cd62a00ff3a0d4ccf7601aa0c0a6831de0a9ee410fd55baf36bf41962795d3"
    sha256 cellar: :any,                 arm64_ventura: "afe91137405dfed4a8e6dbc3dfe21462f73f1a55f46699055513896bd9ebf885"
    sha256 cellar: :any,                 ventura:       "c5490c53e3b8d43bbf71e80ca7e69a7b85c6aca5e21a6e350f3184fe74532917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e717dc3b27cc50ec7ba882cc3c68b8e0b2d5b4d3993b8e178cc168a4f515bb33"
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