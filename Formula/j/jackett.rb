class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1255.tar.gz"
  sha256 "11da06c918a0cab1000385a494abb6af21f9b0842636dd738d518053fc5f6a12"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "61b29deba229897ebb5e64c58322dd5ad7736b32efe7bb07eadb449bc76d4c97"
    sha256 cellar: :any,                 arm64_sonoma:  "7d8cfb3d1d8ac553f9b8e71c7afd58d4a4d8eaa0aba6fa3482659ce9783e9ddc"
    sha256 cellar: :any,                 arm64_ventura: "e478fb3ddc8c99e2f0292a2bdbb1d60ce15668d66995244f407d925ba0f731c2"
    sha256 cellar: :any,                 ventura:       "671115290dd5ddab92d38f8c159ac5b751ed7af55a4ab4fd36fb7ef2b1cf84d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c9385aca8374e8fdfdd3844925aa1a799901b045893b1dd491c5228d3be7f4"
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