class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https:github.comJustArchiNETArchiSteamFarm"
  url "https:github.comJustArchiNETArchiSteamFarm.git",
      tag:      "6.1.0.1",
      revision: "8aa017050e7bbc5b75f378ff5b5a1bf32479a656"
  license "Apache-2.0"
  head "https:github.comJustArchiNETArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ecab78092e78b370e67c80edeee910d13ebca014a774fb381a7d5bba4f77eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5109c8fbc5e18215ecf5e13b0de69cb8514d0dd33bcd4fc6f26047b071acf4ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60691d552067ddc1e84da245baa7328306e2c76a8dded4996a1511005d9a12b7"
    sha256 cellar: :any_skip_relocation, ventura:       "95e0d522f974076801368b7a6f1fbdd27683a738528618b9fdc7acdd04111bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb77fb02438ff9a21a55e8d7f6ee7a0a0a90dc852ee93d56255f2fcfb64cb787"
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