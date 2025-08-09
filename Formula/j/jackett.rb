class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2238.tar.gz"
  sha256 "2d2ebe898a21a132feb5558b7b83d861ee35b6040dda360ced7a8dc9396e9cbb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d44b7c6e431243f2819fc2c4cca68445b7ab3693b1cd241afe39d484e46e2c0"
    sha256 cellar: :any,                 arm64_sonoma:  "09a9e23e408a22b914ba99a224509eccddf093cca98d214f1fa66803257d2426"
    sha256 cellar: :any,                 arm64_ventura: "ac5c75b8ef2be5006d3fc936a306a1e14f24be2c284b9528c502237d47180008"
    sha256 cellar: :any,                 ventura:       "f016366517b44da2db56dd33d9d76ba90da87241d1a5fb81c1684ac885eb53bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "686ef4b19ea6573c1873c03533424489200aea248702b84a6978ed43317d22c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773878bdad148838e3d5209103d10ca4a6649dd15b94ff78339b1f3034ffa2eb"
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