class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2097.tar.gz"
  sha256 "9d9fa363c47de80c722d3e2be5f85ff7cdecab8b35e5269b8ae5cdc98916203a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "410ddadb7afe7187cf012508c6061dc4825eecf51f0918754a1d46c8feb7f4b6"
    sha256 cellar: :any,                 arm64_sonoma:  "ea8ec285ce25000181660492a751516e06f1634cb5b2b4519086503ac8945a90"
    sha256 cellar: :any,                 arm64_ventura: "fb693900c227ee779d7ff8c588e043ed98af7542129bf6a3c535f152d084cc35"
    sha256 cellar: :any,                 ventura:       "362a6b4cd2e8dbbaffdfb99b36fc2e9894a146ac8b4261d0a8437c050a4672cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37d784220824d568f947b95e8c5589b8a7d4dd2b87bb524445a71cb413bbc017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d93d2c18299b1542a68390dc538c1e0697656b6f2d33387946c9cbc570ae6d8"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end