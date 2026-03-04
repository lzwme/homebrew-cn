class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1261.tar.gz"
  sha256 "a92cf3768bd7f2659d824badbedca7d06cc25f4559e06ca7761d295c74b0bb50"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "092ad3962b11baa60848ed3500f01dcdd058441eba549c9ce8f94e8f06e5af26"
    sha256 cellar: :any,                 arm64_sequoia: "fb4509a1ee7c0d124bc644fe87bbdd7ee6ef7a9e29ef9a867adaa25ce569c943"
    sha256 cellar: :any,                 arm64_sonoma:  "e9a753780ad418bdaf1044a63625620693951090f4805054261f4886ac557aed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8457fe6d6eefcb7d3c613d73135def3ea154b8173e8705cd7eb02b584ec605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fb4e33ead709d0e97b938b5cabc41cc329d706ae4f7d15abbe1916cd07e6dfe"
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