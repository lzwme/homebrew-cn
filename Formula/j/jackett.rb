class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1089.tar.gz"
  sha256 "754dd69f206a246f333b478e56d03f1743ad6f9c75e4a0d0850a961aebf52251"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd7dfdc16db710e701e20650693bde153157d686a549710b65142f0ccf4b0c34"
    sha256 cellar: :any,                 arm64_sequoia: "38ecd80333a5eead3f37ecfb970bbc06deb619c1304a4251c608df0b507c2313"
    sha256 cellar: :any,                 arm64_sonoma:  "bbd2f786b42d4f91ff807fc3991ae48811db27e08acbadc03abe655653b6cf7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f489ecc7241fbcd090e88775b6fc71e80cf35376544fdd151a9f99050467c048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46abd0d7b1a8a4500c1035c4d2036f022a8293b95cdf473bfbf2033fbc99857b"
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