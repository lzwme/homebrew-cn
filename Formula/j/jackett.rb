class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2196.tar.gz"
  sha256 "a0201ef77068f6f4ee0797624a58e7ac6a32ec7265f9a8efd1abd786085973fc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b675d15d7fabed33235fc21ef4a3d5db019b62e775163153fbdca17f78b76d10"
    sha256 cellar: :any,                 arm64_sonoma:  "1a20b8f63a304b268b5234c26fb7e66d3352d48148fdb667a329ea532fdd4bb5"
    sha256 cellar: :any,                 arm64_ventura: "cb564c051f108ea9ce15639b8a7d1f1580fb1aa1ac1c583353ec26af87b0f49d"
    sha256 cellar: :any,                 ventura:       "385745e30bea7620a94e8271b87ba55204a6424f6803c74b0d90103deb319fc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "152698ee46c10a45cba76b0c20d8a49190e38dc63758b5700e2deae6c5b87096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ed59c277cb22b8df48c04f8807a17272ad8e4a073eec8d2cb312fc9469b539"
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