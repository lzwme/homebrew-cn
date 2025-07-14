class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2153.tar.gz"
  sha256 "04063f071ff3e1267cd5b835ab507bcf37c1bd449d605866d9a107775c84be5b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5671144759fe4cf534d5f3e989936bf8d96d4c014ee8c3bfb940f05e5e9e56f"
    sha256 cellar: :any,                 arm64_sonoma:  "dd48da335c6713daa4603a572d5c466a4454c44a1bd5be5bfdd82426c9cd97d1"
    sha256 cellar: :any,                 arm64_ventura: "a27c7d17c92da4d3d87dcc59d577c9ef1ed689ef5a67c8b3ee910e54c288f282"
    sha256 cellar: :any,                 ventura:       "2e08328e74c1ff0504ca0201f32e186bf348c5b8657b82d3d24cdc5f611ec38e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95832050d59bdd62d800ed99ff83fc7d61b15bbcb538a5b44b0e88c761db5d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06aca513f9d5847cf05a1214c1d6a9c97a44f0465c13b588e63c3f63b6873f9f"
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