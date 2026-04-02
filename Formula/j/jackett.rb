class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1519.tar.gz"
  sha256 "ab4102163c457d85210226bdccd21b3912e8525b19c196e330d1117909351423"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04faddb3f69a5070c76e71f9ef1e2d539712ffaf0249e1b158954a42b9d42bec"
    sha256 cellar: :any,                 arm64_sequoia: "d1ffcb64e474f00aa65ef389c07860c735c2c8602a8b51ca3b19f265d2d39010"
    sha256 cellar: :any,                 arm64_sonoma:  "47df791c5b1e2c3af89e5b67c9a463f1c45decfba5e3cadd9b4be7bb95555b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "730f9d67693630f44450bf8fea5cabe2a1298d266decafa5daff9ce220b765c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b1e134015460f0ad525cd8536a1cd00f5f36aa2d00b07be66c492892bcbfd77"
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