class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1188.tar.gz"
  sha256 "b5f79aacc1f2a7e55c9d0cae63ed6976785a1c200c8eef326cfa1f0639e0859f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e31722b3d534afb2818c7495b94e72e1e6c968da5fe446d89350c3a652eeb412"
    sha256 cellar: :any,                 arm64_sonoma:  "fc3b8bd6a4288d61bd6305462a86eb631647c8814906bf77bb54d38f2085eaa3"
    sha256 cellar: :any,                 arm64_ventura: "05a25553f6f9b66e5c16473905f2216347e5e953eae20e2728230ff09e1402a5"
    sha256 cellar: :any,                 ventura:       "1c1fd9a380e8f9acd6f8505a72b6d10f4231bfb4f911f1d32cc9dd2786dc9e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d0719d258b113f659014ca6b57bb3011a08fb460c16676f5ced86fc2a66ba4"
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