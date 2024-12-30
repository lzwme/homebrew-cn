class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1141.tar.gz"
  sha256 "39c1e7696cddea12e4f073fdeedeaaeb1fa18379b88719b164a797ab72f81292"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38e5073e189b680e2d9146595a719687c20d09cb1488fc9bcf231cbf7bbd22b3"
    sha256 cellar: :any,                 arm64_sonoma:  "37dddd77b039b338fa8ce0a1b836c4cb324d0fc2b590eb457633628711cee353"
    sha256 cellar: :any,                 arm64_ventura: "a1cdfa9476d224624727d50c51f37fe01523b47f1b2069bb579837c0d155a371"
    sha256 cellar: :any,                 ventura:       "eb92829d076a45da85681b41c8de3ad7531974ed907b1a7f5362c67bfff7623d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b090a4a553d1e2f1169d30b1651eefc1130751db0f88f21cd5530cc860b96c99"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end