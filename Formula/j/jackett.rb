class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.790.tar.gz"
  sha256 "e85bb6384f305ecdc0d1af23051eb49af49530ad8c0d4d42791bd5fa4d666f98"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "89f4a6be9ae60c0b404372468e644383dd7e7e85c208c9a8d15c5df9b63ef2b9"
    sha256 cellar: :any,                 arm64_sequoia: "dc6ca1668ad7d1f1f47eff31707f44c34f505840cbf12676da46e0135aba4e0c"
    sha256 cellar: :any,                 arm64_sonoma:  "22dffc164f5dcbc60649118aa7a684c7ccdec2aa14da7c083d36085fc244cfdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83e1e786ee2d32c68b5f5bbd5a9438c04bb0d64e1ea508ae3ac9fdc4401ca8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "684b3b5c20b89cdcdca4e29d82b07c20131d1ba9b1622ffd24ae2eeb995d7d66"
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