class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2219.tar.gz"
  sha256 "53a13c4c752897fd5193e76af1322054398f6692be7ee8d8fbb0bfa97f698f26"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbdb6580e8335801e29c85a4f1555d8c11be0fa0a782347f3b9bc57b92d6d460"
    sha256 cellar: :any,                 arm64_sonoma:  "a61bdcf25df5f5bfb4c2ec42f87ea48f8566b2eeb97d03669926b55f42b4449d"
    sha256 cellar: :any,                 arm64_ventura: "516a9e1b8af1f266a646cdff9ef31c351873f9d01e96b26bf26d49e41140c580"
    sha256 cellar: :any,                 ventura:       "1ebe45795445e3faeead341f7100214f44a3357ec46d01f7f021ddc4fe2adcc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e03e998c394ca637463f8bf1e6d53abd11676f0d2fbd268f2935a5026552ce3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e37c73f30e6f2fcf3166ec49a81a438280d43de0665553926399ef4b5bbff727"
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