class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1736.tar.gz"
  sha256 "6ce448b7d3708742f040d449b686a3e70e25179cf0e1a6bc75be557ac11a8711"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a4892759fbfddd5eebe78e37de70e42eb55cfc2d1ad37e8058091db30ae7de1"
    sha256 cellar: :any,                 arm64_sequoia: "648ba2dc96bbea8586d62d617d9a76a43423a35b86724911750f3f5521656362"
    sha256 cellar: :any,                 arm64_sonoma:  "fe62ee6d2fbe4457b35efa77008fe34e1946f34add2773b54dae65eb210c77fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdc576a552b159ea66cc4ec54e62d6367981dcab9436380410c963be67fe87de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03fc3ba1bd32b36e4b30b89e98d822d814ac410cb9a35bb25935e589526c729f"
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