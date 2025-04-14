class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1773.tar.gz"
  sha256 "fa2e764dc0538f1d66872360f092e9ad57521cbcd31d8c5a6f4a642f5da258f1"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ffb4249f505d6f99268a0313c53935f54c22a617eeca8b0ffa2b7004256196b8"
    sha256 cellar: :any,                 arm64_sonoma:  "2c925ddd56ca766062fe7449beab21cc22a80d7a1ef41ff103e7fd24bcb31ab7"
    sha256 cellar: :any,                 arm64_ventura: "214bc5ade2e6a4eb68b222d793bfc55dab996fb4fb4c9f97f260e3d4877aa6cc"
    sha256 cellar: :any,                 ventura:       "7cad0a6db97d53194b3b3d1545e066741cb53c95d6d91b94c4323a5109c50dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74c899a2c55dee3dd1e435b7abc9785b8d237182974fd20c3e066c36b844c8cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90206f351067ed78c895966193964e2993d882b456fa050f21656602cbd4c597"
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