class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1528.tar.gz"
  sha256 "1200376a8e88f2c092378fd40de8f3912fcb73ea804bfe3392b0345204c0c625"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69c9b35cc8bac37a9f84cc981c830bc2a5cf46b357fda7b88c9a87c4e5d9013e"
    sha256 cellar: :any,                 arm64_sequoia: "1228ab191442dde2b7d3c25cfca45d39e424ea67dbdb5c345ec1178e00920d6e"
    sha256 cellar: :any,                 arm64_sonoma:  "e33836ff0e87274ca8ed0ceffa133bc50b6191d9986c6a945fee2c270e3ef828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77757ddeb403fefb7d0be089e0c1c5048f445e1f64519c51bb0c6af1f3f30146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e64297f05a48fb2a1cd563274824967fce36aef05134a4ad463b5e9c8e8d621"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end