class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1884.tar.gz"
  sha256 "1daa2aa7519c61047e8fc0298b9bbdfddca4b346a35d483848e11497b73abdf0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a23f43453c4fdc39a9a2ff3f4a4e040d7762e55ba1840fd7db486a58e2f369f9"
    sha256 cellar: :any,                 arm64_sonoma:  "bcb3a5785e77b2a8224198a49c285e172b2440efcc97888369a701948e926664"
    sha256 cellar: :any,                 arm64_ventura: "b8b970489d6c94401040d7555b8f5189cf3c23aad8b613312e44265713e60501"
    sha256 cellar: :any,                 ventura:       "499c0ada3b485f168b0a092dda14b1731ed9be9c7190c1144c180d1d7d379797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85bb948d83e83702681c0ca43741839c67eceb165b9c172b3afb5c6f69989e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0943761f7482e893c1758bcb6394501aec5514eeed4e9b45d4ad022ac3926b06"
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