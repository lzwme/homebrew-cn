class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.124.tar.gz"
  sha256 "74b74bed657e939a40ebb239e493682b31bbe31d88910a4a004f710fcceb5449"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b65935056db519ff42918b66d3333d7bcfad9a9e626fb7802ca19a96357242de"
    sha256 cellar: :any,                 arm64_sequoia: "99fec2db3c4d82e20b2b224833a1a111830ce3319f47b4802f6f6c1d697002a9"
    sha256 cellar: :any,                 arm64_sonoma:  "1cda21be7110291ee6accd12dfdebafcb73a401c1a5a77fd15ef37fef0638056"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbc6a4d9c20a98431a0501446debf18f806b44dc1d210da6be48487046cd7abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1621eb81c78501b0f8e5f68f53f14aa31bf8c834ddb9622f2cfaf611a5c07e4c"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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