class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1058.tar.gz"
  sha256 "75cde0864fff12a227dd37550ced68b719b4986fae4b005bd918fd5e79441b97"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0797fc496b8f8eb0575666463d031d0083993e73b65c45518d8af86ec83b274e"
    sha256 cellar: :any,                 arm64_sonoma:  "70f8f4c5a413e8e0e55043de8bb1c64b175b0a658ab7b5f5d82992f849c729e2"
    sha256 cellar: :any,                 arm64_ventura: "1b5eba797f86792f68fffbda5dd8c14ebcb893ecba940548ce21bc95b5f48b6b"
    sha256 cellar: :any,                 ventura:       "485b1f5a49f4d12a1b0e5b7288177ea9946928853f48ba6f15c0bac847a9a0d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f604d0433f24a5b725c0d30aad64f6a793227acf17bf521d929d2fba97f6cce"
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