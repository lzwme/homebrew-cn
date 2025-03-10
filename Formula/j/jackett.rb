class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1564.tar.gz"
  sha256 "63180115e98d09105f76c00350dab504dc0fc75f6386bc4375c25bedb72b9760"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "04c92a192b896173226e20b1e4e596063c4ea96ad9c55daafa5cc2c3f86bb961"
    sha256 cellar: :any,                 arm64_sonoma:  "913c222328c23cf8035658c149e7d7a16170b0962cb68ac20d6e2a5c56bab0b4"
    sha256 cellar: :any,                 arm64_ventura: "695f2a4ee50ca86b8d1b9aecf4577eb1cef3d294af7c98ec126b0d57ae2d5d37"
    sha256 cellar: :any,                 ventura:       "89bb4f0669585c5603730e34bfa0dad2ba67ae73d87d5aa46059534911bccb20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be807c4f4451c37f710d9f15da25ab634a43e9c150421d260d320cc02c5a80b"
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