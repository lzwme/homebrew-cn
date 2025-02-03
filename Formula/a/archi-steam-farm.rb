class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https:github.comJustArchiNETArchiSteamFarm"
  url "https:github.comJustArchiNETArchiSteamFarm.git",
      tag:      "6.1.2.2",
      revision: "0a2ce30c82dd0a7b1f7b3cfae15f254e885b1703"
  license "Apache-2.0"
  head "https:github.comJustArchiNETArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf95eb89d68f244e6da7ccf814e47e0370bf2d3eae58863c9a5df654c9684d37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64b4672bcba901890ab108335e9edf09ab328a7a9ef2cc407b513779f7e847ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32725782e49c3e1da94fe8f14d2d791e726c07d19c5b4c116670d27eb2e46cc2"
    sha256 cellar: :any_skip_relocation, ventura:       "48ae08514ba54721b4d0bd1353df4b973fb406b9a095f213023eb8359fc5247b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73bfd828f6d3f24ae2b57b04be13e0653c8eecb10d87819f543430303460d0d5"
  end

  depends_on "node" => :build
  depends_on "dotnet"

  def install
    plugins = %w[
      ArchiSteamFarm.OfficialPlugins.ItemsMatcher
      ArchiSteamFarm.OfficialPlugins.MobileAuthenticator
    ]

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --use-current-runtime
    ]
    asf_args = %W[
      --output #{libexec}
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:PublishSingleFile=true
    ]

    system "npm", "ci", "--no-progress", "--prefix", "ASF-ui"
    system "npm", "run-script", "deploy", "--no-progress", "--prefix", "ASF-ui"

    system "dotnet", "publish", "ArchiSteamFarm", *args, *asf_args
    plugins.each do |plugin|
      system "dotnet", "publish", plugin, *args, "--output", libexec"plugins"plugin
    end

    bin.install_symlink libexec"ArchiSteamFarm" => "asf"
    etc.install libexec"config" => "asf"
    rm_r(libexec"config")
    libexec.install_symlink etc"asf" => "config"
  end

  def caveats
    <<~EOS
      ASF config files should be placed under #{etc}asf.
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end