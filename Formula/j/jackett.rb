class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1947.tar.gz"
  sha256 "f80e3ad3a5797bd01d3bc27fa32d2f34c8eb870f3433ec7982e4d31da464712c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e77bcb503a287c65763b5fc71e3a4aa1330c0ab8b1fb5bf08b26f6ea6035502"
    sha256 cellar: :any,                 arm64_sonoma:  "2d34694a1ba33afa6c827dd0245b754e824f52e65835b91d0ff30c9e2ecf7dad"
    sha256 cellar: :any,                 arm64_ventura: "e035d2bbebef92a221408b8458ac82b16a3cc762d8f8bc42ded8c83311009926"
    sha256 cellar: :any,                 ventura:       "faafd7e6ab62b7766be7241e9474d28de7d508424b68c43cc847f124f4b665e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "317e1e864854c0945545cf6c904dacf9a0a372ac69a64db153931031b4ef4378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6f2f90202aa7f81fe93fc87be4ac0d5b3e6f2c35647c7ab9a1674580ae98e0"
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