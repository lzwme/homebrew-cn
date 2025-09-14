class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.17.tar.gz"
  sha256 "8d56f1b8caf476c49e404d391212af6a59871046c64fcf52f0198ea432a074d2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d7ad58f4121147a287d7d7dd3a705f298dd00862f1d4c71c6caee06a537524c"
    sha256 cellar: :any,                 arm64_sequoia: "e2a6aeb762017935ad2dda3e3ffc7d5df8d1327ee353ea40f4941c18baa05730"
    sha256 cellar: :any,                 arm64_sonoma:  "f99a28f51657a2bb458cb9cd1fe9a76ed672be730280f5d5cd027bd898978579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "800efd8899dbbd30a9547fa168eb0efbdb4c26e4a1739c1268ce62e264d8ddfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e4819dd6c902feaf45a460dd41da20c4f71f630c3fe4f5fe2e274990eef1b7"
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