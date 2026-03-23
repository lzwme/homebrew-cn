class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1431.tar.gz"
  sha256 "c04e616862571d48bc8f46afb98db20d2397a192a59aeaa9ec4263925243888a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6539b64e35560dcd0d0457ca6ba1efad34a05fc3559040da7ee4189986ca37f"
    sha256 cellar: :any,                 arm64_sequoia: "c903050f9a0901cb32feb07b79b7630c93b699719b5e5586f03e6e4ba60d4973"
    sha256 cellar: :any,                 arm64_sonoma:  "a99e2abe1a7a9af309c49591d37adbe00cdeda4437816dc3d5922aa323db3620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50e35c4c76036fd72d8a835af8da4fc3041d6d19bd8fea4ce08eb5063a19e3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b08619486da47a2498e72e1046707d95c7beb35e8189b0048da1179f078dbf1"
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