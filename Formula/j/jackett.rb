class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.399.tar.gz"
  sha256 "a7f4bc661a3ed14ea67a995c840c34f22b6bfd7371aad9a47295e4dc818cf3bf"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c2a9f126fcb3f592b83fb7395da7c6393d34e9ece44817f84a4c0b66e869517"
    sha256 cellar: :any,                 arm64_sequoia: "0cb878b7ea9c1c4a9fa64bc99d206302f9a838bd56cb782b4a8e5c3346d2288f"
    sha256 cellar: :any,                 arm64_sonoma:  "700ba260a2fb432d697d8c41b71852ad16ea5ad06f827c40b1c1b8f92aba4471"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b220fd45777ffa6c9ce12e95adcc5de036976a02024a33d162dbc3ca49cd50a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6469fede6e1f04eac528f3a5e53f37ba14eb6a429f0358010f971002e519e8e7"
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