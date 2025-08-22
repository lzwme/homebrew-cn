class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2319.tar.gz"
  sha256 "37449b22725af9ba0941e31d07a8f7602e4eedce8df1836dacd89bc046ca02c7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "418a438d9c2a2b0e432081a161998009d732666b5191c779f6ca6d18843891cf"
    sha256 cellar: :any,                 arm64_sonoma:  "849d167f33c2c6c59c58fca81a4d793276969a1d1bf1e2bc5464180863c67069"
    sha256 cellar: :any,                 arm64_ventura: "2d82cebd909a7f9ed6ad6997c7e38811ca02a8a772c686a9c8880625a5af08bb"
    sha256 cellar: :any,                 ventura:       "b46d193601eec1c1a5a4f9414c4bebcdf4d28e6edfff8610bd08a3aefe9ee9c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec0703c9f3168687fb53a32091594fb2cff2a2ec3ec0dd46f7672791a99bd981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4a27e6bd812ff75b838989f045bbc615b55d636b68aa5fcd4d7a2ae380c1bcc"
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