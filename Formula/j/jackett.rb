class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2225.tar.gz"
  sha256 "bd4a35185d436b1163e897f095bc251cb6102b1a3edf56e3a86ab9afa8e8f294"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bde2c5facfad7a625a52abaf2512ea1388f84c3fa45a51d9eb31d3ea59a53871"
    sha256 cellar: :any,                 arm64_sonoma:  "1b6dd5c1362c4a91601cc4a85dd2bd2be4918d3700ef1fd17b1b228c5e1b3aa9"
    sha256 cellar: :any,                 arm64_ventura: "9e375b78b4bf8e25c48bad330aa8355a7fdb6e0c342672bce68951bbb336ebd4"
    sha256 cellar: :any,                 ventura:       "3a11b363dc1284647b2689c5f5816efa3c1b86a889754bdeff21067f7fc6d72e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba6f94857e6984e7cbf7df72728edaf3151203647af9a07df4fdfb480d69ee86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa57d2bb3f1256f7b658a12c10c5b810e7b8352b5af4ea58e825b98eb2892c71"
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