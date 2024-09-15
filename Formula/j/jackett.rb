class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.600.tar.gz"
  sha256 "a63c81538e5f856fa836b6fb8c0299b9a242953f3dae2530d2e3cbf116516f7b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "8cef059199581d8f4b93cd9839768b577eecd108e474c00280186db32bb5b07d"
    sha256 cellar: :any,                 arm64_ventura: "0b6a9d6a325fc03623a2ba540aad0909ebc2a8473f981d34f3a7f39e9c50f592"
    sha256 cellar: :any,                 sonoma:        "5f67124d6ecaaa2612289532cfe17cba537fb149e4a9b9571ded6c07205f94ce"
    sha256 cellar: :any,                 ventura:       "9bc215de6345c1bbed8a70c266dc9d354cabd7b33415bd46ccf664ce82282665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac571b64cc6825f5aec3c8b84a3025c57a61cb12d72c2e2d983f4d8ae5db5635"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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