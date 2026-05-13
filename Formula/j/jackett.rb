class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1846.tar.gz"
  sha256 "b17deda33d1e56f069fe84765bb29db892936107b67f5e08e1e5990150705a04"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5847077db0b14a7c8b36ecb308668eece61f9108b02200de6262329bfcf2178c"
    sha256 cellar: :any,                 arm64_sequoia: "64a66c363ff95ae92031c756b56ec2c2ecd71e3bb01311a93f2f3059343a5f85"
    sha256 cellar: :any,                 arm64_sonoma:  "ad372d95dfdfd7274dd4a170c16789e7eb8948e9a5b8c4551852f3d78a6da809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9552cc7184391032b394e92c47ef817383280a027d94db65646ddc090e365fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c5904778d1dc41eb3daff8da3b1fecf81ca41f863ce5677e3ca031d3d8a8f45"
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