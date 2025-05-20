class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1921.tar.gz"
  sha256 "ed16db87d91c91a407480be0305fad9c085df341b3ac45c4da7e87098c93a741"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "083e7cd1a3c255fc50a7e9abe46428b88ef0b0dea288749ec33a140f98f3d766"
    sha256 cellar: :any,                 arm64_sonoma:  "25cf03d6d775366d13182c72f21921801462752a081e42cf27b8a00c9ef4f0b0"
    sha256 cellar: :any,                 arm64_ventura: "2da483c4f82130e7c9fde90392a7dae53c90828eaf57f72923eaee91a62db9a0"
    sha256 cellar: :any,                 ventura:       "e7a09dabf312d7bf943668b3e47265ecccc0346cbf8f2f66d08f8e8767dd6a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "769bb65f876f5ef02d61b73a638cc13434093efdc50680ab19ac03addb270fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc656ef0e9719036d91f18a792f6ed65a227a56cc2f52f3e25f5cafe0900f660"
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