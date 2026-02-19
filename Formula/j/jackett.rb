class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1147.tar.gz"
  sha256 "90462da8c043bf51dc03f349d212ee67192b623033445a6b45966ece9dd6dffe"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65b1b2b50211e880d0e70aa2b8bdfb477d054bc44d2641bdd71aeecfedf26a99"
    sha256 cellar: :any,                 arm64_sequoia: "82901f43a17c1392fbf8c460e2bfb3c30686fdecec77538df2bd090b1974afee"
    sha256 cellar: :any,                 arm64_sonoma:  "d23ec2f1034f0a736736761b67d6e957c01b8aee7bd4925cbc25be8c1276b8f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "208642091165e352ed1f0d64fd72b67bb15862ed6e5b951bad9b26af273cefa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356f3ed6ded992730266d9075f6b6d275d833da622d7bdba2f0ca435aadc7118"
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