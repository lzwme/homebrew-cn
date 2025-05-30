class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1967.tar.gz"
  sha256 "f33782bb360abcb9535b9902029acab10cd772ce4267bf9ad418f8c862a3ce0b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b7b8976064fccad646097a9fdd3a71bcaa74c3dc2daf16171177a3bc5cd57923"
    sha256 cellar: :any,                 arm64_sonoma:  "56fcef5c895d255f208cfef44f0d131ada05a8551f3582993b43e81248a27e90"
    sha256 cellar: :any,                 arm64_ventura: "33470ed5a48843daf60093faa5dc0df5e2d60b27828d1a74e93da783d5c1b52f"
    sha256 cellar: :any,                 ventura:       "6828e172b23f1d6cb071dcdbedf264c19aee4b85e6bfeba0feb5daa8bbb1b556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1ea69b6a1a347efdeb1118d5b45a077c8ea8b857bd3e7ce8fcd935027505983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e87a5660e489ee276e8173c4a8c16742ad7b5bc89596374b93901a3fad8ba55"
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