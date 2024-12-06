class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https:github.comJustArchiNETArchiSteamFarm"
  url "https:github.comJustArchiNETArchiSteamFarm.git",
      tag:      "6.1.0.3",
      revision: "d21912dcd96f465e8eae4f958ac5be0bfb776662"
  license "Apache-2.0"
  head "https:github.comJustArchiNETArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72bd2a6b38b4f6cec5fda7b493d9ed67a4f1c9f87c65a376322277e2a7e70d93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cde5bcdd6c03ded7913e3933499f315db6ab1c671e70dba51acd7fdc9ba84606"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46e8e2a7a5b670ad6dac623189915f31cc58c8525359603f49f338c2b2ce5c2f"
    sha256 cellar: :any_skip_relocation, ventura:       "9f68c8682b7c7051addd5b005a501b411d71b154df049b83ac6e1af19ab900f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11cdc187bc841528964c4410f4614891055fc85c042415f5c9cdaa2cdd843bb5"
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