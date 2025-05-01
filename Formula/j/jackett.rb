class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1836.tar.gz"
  sha256 "b6ef0e1322163e7681c9a975a8c0722639179cf37d622c9c7e5ca104732216dd"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "57783e47e7ac59bfbee54e42cd8e492d66a8f87972a7b0e7db26ea298121868c"
    sha256 cellar: :any,                 arm64_sonoma:  "515f0a136bf2f31f0d00fa57df931284b85f49eeeb32bb13c0c45758b0298024"
    sha256 cellar: :any,                 arm64_ventura: "139313f6c709c2ecc980a1ec20dd729b8885aeba59ca855a7732af6c875cf59f"
    sha256 cellar: :any,                 ventura:       "c5d62590bf7273f773ce909f6b349f3586ba509be0915f79e357e3d3e58c1da8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fd2679f50b23a5d808c02375d48f91597205830ef4f4e2841365c64a3931734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1de6a14483e20d107c2697d7b84469304eddcb34aebbe9e9402f50fc69a5497e"
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