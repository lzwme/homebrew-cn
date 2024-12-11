class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1063.tar.gz"
  sha256 "0a696c44631414a86cc3da96b98fb3eb16b8e685259436dca3e10d64d722f15b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbc2553c68d446e054c1766ff1bf94fcfe52115045f04f1e49c735427eb8e491"
    sha256 cellar: :any,                 arm64_sonoma:  "d6071cc16fe08bb2a0c89c855d753a4b4bf033d641a675957fc2be28ac7ff12b"
    sha256 cellar: :any,                 arm64_ventura: "04aa92bd5130f3d965dbf6a7ec5f713ea3fbd4084221f6fbedb331207aa6b809"
    sha256 cellar: :any,                 ventura:       "ad3e2f978dc65295cb3cbfde033572b70f31e69e473ad3c4a0764c8e26154ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516c5939c548e0bb9bafd1dbfd7ea9619d29a8d8039d263050ed24ed4275086e"
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