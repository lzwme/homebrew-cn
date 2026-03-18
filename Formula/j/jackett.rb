class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1392.tar.gz"
  sha256 "38adb7ffc2ce71b19a6d2f5c07935efcb3aad9281f8bbbf3f69bd64eb181ce95"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07b0233b798fc3a7b1624c0480b7145b6dc16532d38db09e1a311dd05d7e000c"
    sha256 cellar: :any,                 arm64_sequoia: "4f6bd38e91a74c27d47c7f46eb4707802181088bb0f8282c9af16bee34bdbe03"
    sha256 cellar: :any,                 arm64_sonoma:  "84af5c886c6ac675a4c1360d387cfe51cdddd22a3b557edb79faaa4d2f54d065"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdad28a7ce0a1487e565db3ab31502b2bc55cf665baa0effd4a2c279e8588b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73efb0cf42df1daf1db8b78960f56ef7ead9dbfd3b8039ad7a7ba3693f844f16"
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