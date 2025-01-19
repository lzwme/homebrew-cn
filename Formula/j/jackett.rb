class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1283.tar.gz"
  sha256 "1b98c26efb21b0cbaca02c524ef23e04106b94a8eb3c91f7249ef3a04a4f183a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9fa9d58f8fe3d600e943860b4e74ad854c11757056315f8681bd9cc9b92417c6"
    sha256 cellar: :any,                 arm64_sonoma:  "974f1405f89a75096606eea13eca6e6adb358313d8a71b62613feb33650c03a0"
    sha256 cellar: :any,                 arm64_ventura: "f87c276e0f4aa7f05d4c299e9907ea15cac7566f536be85ef4852e37b65d6031"
    sha256 cellar: :any,                 ventura:       "aa6057a7025a3304ea153117d5c6701b6ab0d544009261d206146163069f71b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c9c927c83cfaf211b6c24240e80c50310f4bcfd068127ea277d0cc67d987b5"
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