class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2084.tar.gz"
  sha256 "23b9b4469ce539d5ec28d675867bddcd23b609bb620c8a95ff477872eef2511d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c83eccb2c71371460789144375f5783cd53275e30c1f951c4b40d00acb308273"
    sha256 cellar: :any,                 arm64_sonoma:  "3b4ea87940eb30454ea3e908d60d654370956bcc006ab87198ebf8fb8ddac179"
    sha256 cellar: :any,                 arm64_ventura: "5ae84911a62377f0beee543132c231696ade6f09f8abf2535f26333a93c0609a"
    sha256 cellar: :any,                 ventura:       "166583ab20bfb507647bb7132bceff2ca93842247a6368fdfeaa6cf8c40f209b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "563144de87eaa2a09f5672d276e872bc22ccd4365f96e7f1c20f179119883b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8649a1e34617a05a79aaa57581c067ae158fc89a353fa7a95b7f6415aed30a34"
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