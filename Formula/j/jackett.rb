class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1128.tar.gz"
  sha256 "b54ebc2880f96ca37f70f56b033b7a15cf001ae0150b1c1172bda54d07a1cfc5"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35b4d410175aeffab0b519b6e037976bd7588510b030043e3264905d364469bf"
    sha256 cellar: :any,                 arm64_sonoma:  "6d2a8fac4d7313dd8d362cf6ceadd6c195c0ad4076e34b5e6e39c5da51362db6"
    sha256 cellar: :any,                 arm64_ventura: "a372272451c03f41ca2b15a9ebb8faca2e76656555e00b7273274fc20221a1f8"
    sha256 cellar: :any,                 ventura:       "d72af13b331da8cfaa1f11c8d8b3edcd03e4674ad00e893e04c08d4607f94b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29cb6813ba61ec02b1ff3c5d38b2ce200f96492c0d5364abb6f9d7cda9a9ac1"
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