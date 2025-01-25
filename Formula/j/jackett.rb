class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1305.tar.gz"
  sha256 "eaea948fb695c237cacf782c2e50b07bcd9d2f840b4562750b06b9fa79045788"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf94696334a6989e7a4b22a56cd354f0b937f3a4650cbb915bc0518174ee78b5"
    sha256 cellar: :any,                 arm64_sonoma:  "bc692239c9031d6db5096a71d578e4e85062aacf95a7d5d9ebe5b03717202b34"
    sha256 cellar: :any,                 arm64_ventura: "7e414a6a31bd4a78cbde5a2efb4a61043fc6fa2b1be783ecfc565f8663fcbb9d"
    sha256 cellar: :any,                 ventura:       "bd02faba714a65c1962c0116e9f65e66b2b9fa82297b08bb11cb4f903f6bcd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03f27656ced1932fcd65b4c468df696c7155d1977292986475680ddd7da73df8"
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