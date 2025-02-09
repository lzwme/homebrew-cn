class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1382.tar.gz"
  sha256 "1a666234bdfce44cd9961e218612e0233fe7c17d5b0cde725055e1e9ad63b9db"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1e7a9bde63ce64ac3b3af51a90efed54a6febaa67559a4c9fcb6e2fed646f19"
    sha256 cellar: :any,                 arm64_sonoma:  "afa2d3df106a4ccb374d0a64ffad4ce497c7f82009f00a0d23c47524060f1760"
    sha256 cellar: :any,                 arm64_ventura: "c07304dcfae5bceec6c323176e8ba39b2c58b700dc4cc3d3c44c9d43b754e927"
    sha256 cellar: :any,                 ventura:       "f825c5f3190d4436540533e07051be25ec0068d82f948d878ef420cf8c0fb28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4620a5b14a5dec6225964da4fcc91430a0ae912e7178c6af98d9f4613e3e16f7"
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