class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.512.tar.gz"
  sha256 "1a56ff77b12313030c8366e712aed361a2cc56312014c0dc2bd8ef9b0cae3334"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fba22031a18ccff3996f4c4501fa28664d5abb796e6ba9ae795201b2e450f221"
    sha256 cellar: :any,                 arm64_sequoia: "8ac29e8a4f0202b7f4b33802695e6bbb0460a88e004ab191b39f8e30df7cf2db"
    sha256 cellar: :any,                 arm64_sonoma:  "cd514ee33b008574678a2825699e249353ec4c15d86a92fd85835ad17366ff02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c39605de563a983b4c4dcca709b6cb13755ef8949a6cea25ee901a9ef31a7828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bbbbbaa89841502de27ecda6aac291aa698adfb91e3365b2efe0d068d5b4553"
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