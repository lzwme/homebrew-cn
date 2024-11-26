class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1003.tar.gz"
  sha256 "c9ea1e7f7d1a526b70a3b91e8ece2e16760925f0a77480a68c171ca083a687fd"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ecb86c44525f82b42a541db54d2d11d10a55a87062ac2dbbe6e6e9e24cd406ae"
    sha256 cellar: :any,                 arm64_sonoma:  "7c13c0c30d03d3d4713feadf8013beb56e389aaae4734fb32b9b574ef5cdaf0c"
    sha256 cellar: :any,                 arm64_ventura: "4b143f1e3d5a4eabc9c02c72762b3dcdd38795f9a9f9b61653a3e60f437038a6"
    sha256 cellar: :any,                 ventura:       "21db055144d14239e0523ed86ac074d1f138c2c2e18f9ade6a4d1c4f720480b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6f7787b5cd646ab26767305b657a5e911ee982201a8ba10a391120de25c4e73"
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