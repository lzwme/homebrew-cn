class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2335.tar.gz"
  sha256 "a1959b048fb74d232b87c5a8f8e5616038bbd73cb8168475421d840a39442359"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "65cae0aa3d0d4fbe1be01719494c04face20f9e6f65821efde916f283c28f35a"
    sha256 cellar: :any, arm64_sequoia: "30e3185610e310ac8a41de2a6576c6e89a045ae04f183deff988b5bc4f6e821a"
    sha256 cellar: :any, arm64_sonoma:  "02ebe92c8cb53df17d7dbdae1404db3e97a7a14e313f08c3933cc7750b4dbc8b"
    sha256 cellar: :any, sonoma:        "3beb41257caef339635f36a454282f93dfa9c3be3da6bf5d3b7568db7baaac81"
    sha256 cellar: :any, arm64_linux:   "25fcc6c767a50a73c1806ab7d0cfea418b7278345c4998cd26eb933e9f81cb08"
    sha256 cellar: :any, x86_64_linux:  "1076f4025a4abe6b4049826f81f05567ec26962c0f3730fc47b685d3193ba8de"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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