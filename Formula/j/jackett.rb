class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1428.tar.gz"
  sha256 "71caabacc957e0b98e3f425b76099000ac80dacf22077ffcba5f012fb1bb12f1"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91e4b44e7f0aed1432ccde8e00c39d0f8b2bfcd4e049d198fe021211ec79b195"
    sha256 cellar: :any,                 arm64_sonoma:  "2c4b3761a7fee8f5e1a58c5179fb2af92d15fa9b860a3cb02a5f9e22708f670e"
    sha256 cellar: :any,                 arm64_ventura: "f23f49539aba6f1d75042f1af439c19aaf2b06b0ddb3ec61a9d8466bf9894192"
    sha256 cellar: :any,                 ventura:       "3433fe6bcb4bba5e13010d4ef3ccc5e1a1c23ee9e5b4a5832570f8be601cecbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be32a64566e6e30b8d02214634297c3c4c9c6ebd0a1f5f13a95ad7f682e750a"
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