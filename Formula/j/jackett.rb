class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2217.tar.gz"
  sha256 "fb9980468d22f4ab8f8417abf06ccdecdf44fa8973b2d042b800d345e9e91c3b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ddfd5f80185cb0866537ea087ce689747e5f07366bbee61b97b5accfc720c4bc"
    sha256 cellar: :any,                 arm64_sonoma:  "f4ac485cbc5a2d6052d70a46b08d1cb9de08564477edfc29628dbb8db422de45"
    sha256 cellar: :any,                 arm64_ventura: "eae5677f018644813429667a23dde7573bf1514b29cef5d86c51d70c6362773d"
    sha256 cellar: :any,                 ventura:       "f15060d1118b84b6f24a6494d83f8ac7a71a2a7620a3e1da987e4200bbf2550b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee51c4f2838b627cd2cb068d980816ea2ba769a691949eea56c2e8e335645b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfb6c1e342fc83f30f665b0400e443b3dc748c65055def3f512298208d177570"
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
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end