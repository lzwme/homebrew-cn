class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.834.tar.gz"
  sha256 "64c66699d3ca627bf33f7bea8c28654f754d4e6e7423c570fa3ac067af184e9e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b046f77ffcbdcc4ff164033c23e2fa89b1c0e2a33fbf85c590ab2d046893609"
    sha256 cellar: :any,                 arm64_sequoia: "9356dc2a4edd5a31e62ddf83597c6b15ab4c762d8c03f261a0fedef4c566bf0d"
    sha256 cellar: :any,                 arm64_sonoma:  "ad4bfa6e117a120d3f4065d68ff1d1e52a72abd175737a65ebee3f1029658100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e35707106e1f01e64d457306c16185c6c6afc648e5579365fd32fcd943ed889e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f1cbab1b8026b0d06cde13988f13c9f0118814a2ea64306f425ce324e90440"
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