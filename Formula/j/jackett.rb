class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1974.tar.gz"
  sha256 "37bc7f72a1b2d79b7516d4c0855e4de3ff762278de2611fc80714a3ebdbe3e1e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3f8482159092deb26614dff5da80bd0e2ccaec062f9f1554791e777b98319a0"
    sha256 cellar: :any,                 arm64_sonoma:  "94d23942fbf6fa5d261f5a2b79f118cacbce4b3d9bf01e330b1d6b312db80b8e"
    sha256 cellar: :any,                 arm64_ventura: "5424c9bf09c5a38cebcb9c6226cd918005b019134cd99748b8b3dfb1ed155bc8"
    sha256 cellar: :any,                 ventura:       "5847e2d01e9514c0d35d43f78f0c610b813703d7890bf9415d4024da9a136b32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44cecd00127e08bc932ba3327d9a38d1e32b7ecaec4182ed1e2ef3effa76d8e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d5c2546f7d383330c60c3ffd723601f6b712014596849a39acde6594e2578e"
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