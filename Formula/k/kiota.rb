class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.22.1.tar.gz"
  sha256 "7346de77678689c6bef6bc7a03dd7724462a33b142891f1be64a14ca76d1665e"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b185e751638871d219614a96952fe4dfdd6f91f990a5e8c29e3def3e789eebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8db11e05470201a8671ce5fe15cba7cc5bdc7bb9bf739cc9f013a6a42df06e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0af48d652eff38feea27012f968841332b41895a4d8606c860866f9f57479593"
    sha256 cellar: :any_skip_relocation, ventura:       "8c4c8c3e325234b44c945bc8086af6129b369037f360668b49556ff6b657f1bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae5c13e7f6d0497d23a117e9f23e6fb2682675d0952460c6bf17a4792d07268"
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