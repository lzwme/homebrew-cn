class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1608.tar.gz"
  sha256 "441b590c6c5fddbfd70a6d017fa986bc3747613f286f126b0c1aef887e6d39f2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d2fb38bfbf93d64287b342a091f1b0fe3d48742e3f9d334c1fdd2617c83b106"
    sha256 cellar: :any,                 arm64_sequoia: "a4d826adcee77d1965dfbb5e1a23ad46d9078270e40fb4db7ac7968a7e045a2f"
    sha256 cellar: :any,                 arm64_sonoma:  "caeb9dd3e614a1a377f4355b8715eeaec2b5ffa840689799b305b2d1687dea1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb00ff24b91d356b7e55b52fd566b9da7f82b33f6ce0402df46909acf02cbc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "485ded1268e46f626d637f2ff83cf1b977977d820b776783ee6cecb104bec426"
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