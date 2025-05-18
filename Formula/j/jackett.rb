class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1913.tar.gz"
  sha256 "6d843396bf3579bbb7b36d0d025f6ee546b43c87fbc2a05e974aa9c1e0bef34b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97bc433fb536ffcaa074a2061b8fc3b9a81309cd8d6e043338cd5b14f244bed5"
    sha256 cellar: :any,                 arm64_sonoma:  "98961570f471773a5d36b1410baac60eefce23d3e4fa79a5d3674cb56d1be846"
    sha256 cellar: :any,                 arm64_ventura: "b7a2477d51f3ed242dccc94a1f25ea7b2ca0b38e2277e8110f27ed77f6946c2c"
    sha256 cellar: :any,                 ventura:       "b7d12a25fd987b9a477a03b364e6b091cf97f49e221f23bf1ebcd7d549d0b653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "158dd1df1db2be0285fb7bb40d719b27a670460b4a05f1176197f90742c7e31d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0fa21f48e89aa049fd94863ecb87522a058396c699854d47492b18e1df133e6"
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