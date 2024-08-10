class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.427.tar.gz"
  sha256 "abe5137b02bb6619aa332027e0b7d9e768e225b157c4a5f2e387df7c7011d67b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "561f8c7fa230c0e9b6b484dd68b509bc53f61addb7ac05a298b0bf6892452215"
    sha256 cellar: :any,                 arm64_ventura:  "b69f8e2939f74dd404efb65a56960452910b61d701c83ae4cfda1dac856b87cd"
    sha256 cellar: :any,                 arm64_monterey: "97cd4c0e6170aede1dfd8bd53a1509f7bc27cdcceaa84598b3b370270779c48d"
    sha256 cellar: :any,                 sonoma:         "f34bba4e0c1cc2c96a828da1c48d451d9ce939631acc847a14e786cf23290735"
    sha256 cellar: :any,                 ventura:        "1b05f08e1688f834bc17b9ebde83c6855bcfd33f5d16b19983677b12c6da5ecb"
    sha256 cellar: :any,                 monterey:       "28da30201dc6983584083ac1f6145a6dd6a141994efd032737e88c4c7eb2e1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70e94106409d12c80ee1fa55b839c12339a8f9f1a319202f575a392b83ca79a"
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