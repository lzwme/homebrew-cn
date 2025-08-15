class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2286.tar.gz"
  sha256 "7132319e68a47e3ec6fa6c6fbcdc3c12630934e224b03076694980a4a21c32ff"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a035ab31c4b07de19a34236913e93afd572a0e2952c036ed34b6bc4271c6113b"
    sha256 cellar: :any,                 arm64_sonoma:  "c042f268fe8829d534004bceb88a88e14482770985b0d2dcb4b666ab7a544292"
    sha256 cellar: :any,                 arm64_ventura: "5dbd9309768b7517cf945ad8dae78835e164bd562c9d90152855cd0892d89e45"
    sha256 cellar: :any,                 ventura:       "7bef9c0f3c6e66f9661ca4c1ad3e9204047ba0a508acbf89f7b10afb3521b53d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49c06213e9c4868c5e93fcc6ea62ea1974a6247acf248d74ef0e9c079470d360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9da8f1de995509e285c15c51c0862fad5e99eb40e51a417bd939ffbc647b6c99"
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