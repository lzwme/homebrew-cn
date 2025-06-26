class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2054.tar.gz"
  sha256 "51074991eb5b0343cd3c2929e62f28e25291e55a8d42fa5973b6d1b526ae0cfc"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a5552783b601e00dc80fe0f0bc12c9c70a4fd3600e5e0ebcf080ac288c28737"
    sha256 cellar: :any,                 arm64_sonoma:  "6d09a085cfdae0ae7b13d949eb0aee6c58939fc2de0ca0aaac02f59e5694f1f7"
    sha256 cellar: :any,                 arm64_ventura: "23cf9c6ea95e2a9ff9d1243855a73a33af0c294f4bdb8a6d4eedb728c6e7adf1"
    sha256 cellar: :any,                 ventura:       "a84f7a30ce3291d0b35200a0778db1644ccd0ee0bf668bf81810b37ad9d2ecb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80fafa1e5ceaa5ad8ea04e5712cb107a82c21fe714556bc38824b2a1f9c9df69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92313d574ec172ebc879cc6c50b120278cddfc461d93c71a36348a65fd9186de"
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