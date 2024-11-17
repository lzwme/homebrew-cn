class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.20.0.tar.gz"
  sha256 "2090ed62884c77ae26ba1f0c37b9c250c2dc7b7229c0e18fbdfcb67c8b2c96bc"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "865c01272fdc2876d975e803c3d53f9ae79daf3df4b25610ec597ed97f0e24db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc0a93beed7dc18463c7fde3439850274d7e4deaf380b4adfa4db8137471a180"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83f8bc3a3ed1077dd2c7c0d0713aa2fcc11c673d8e1c62df070ea6a0bc412401"
    sha256 cellar: :any_skip_relocation, ventura:       "19c59b7d77264e17ba527926f1fa282ffcf5cf602552edff9e135d48605c27d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b665d4cc03d6f7bd1c6f70c63e2cd8ab114f6b314dc7c00fef5512340b8fcdd"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
    ]
    args << "-p:Version=#{version}" if build.stable?

    system "dotnet", "publish", "srckiotakiota.csproj", *args
    (bin"kiota").write_env_script libexec"kiota", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kiota --version")

    info_output = shell_output("#{bin}kiota info")
    assert_match "Go          Stable", info_output
    assert_match "Python      Stable", info_output

    search_output = shell_output("#{bin}kiota search github")
    assert_match "apisguru::github.com                            GitHub v3 REST API", search_output
  end
end