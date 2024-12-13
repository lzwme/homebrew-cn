class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1072.tar.gz"
  sha256 "e3d35e089c9c0b880bf3c3c9df6c1f428d415c6e92778d0879d58aca1a533928"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a2559a2c24b049d8949ea36ab81ec4423a2817b66b588e41f4b96cfb9284c7e"
    sha256 cellar: :any,                 arm64_sonoma:  "153bc9c1aad03e60312a4dde0ea39d5db4cda32e3be86497c8308adbf1cdc756"
    sha256 cellar: :any,                 arm64_ventura: "cc8db27c784e29e6b5b5fa823af3dfc56efa60ca574f8238e3a87b8f71edc0c7"
    sha256 cellar: :any,                 ventura:       "3247b413efaeb16890971187edd26c3b217e598a59f77e380f12496ac0948a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b5d1df8a22ce23ecc5e535e689b2aac477940730df551eb0f9f906363697512"
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