class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1680.tar.gz"
  sha256 "051df9671dbe54a55bbe229620a7bca247aba544480d70e8f6a5827bf1193227"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "51a22b9bc5fae9b441882449fe362f4cf30907325cf149b58685ece5a956477e"
    sha256 cellar: :any,                 arm64_sonoma:  "5296e9a584766d139d11d82d11cd0e94e145e1c4af87f08e4cab6ce06c5ded71"
    sha256 cellar: :any,                 arm64_ventura: "f9977666351bd8f3e9a8c24381daec38a2cc8a3095d271d1e63031734f501666"
    sha256 cellar: :any,                 ventura:       "55cab47c007f437d38798663625eb9bf19588ee95a624e94fe043c9417987e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91eaf4f20e39f0ab60173590e58b33d8a31ae5c1e0b31db17d52c11d5e69df92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "001c7b6d18eb0126b4f479ebacd451a2ad061c8de8447e7b1635aefb474b969c"
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