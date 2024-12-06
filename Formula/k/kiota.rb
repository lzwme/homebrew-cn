class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.21.0.tar.gz"
  sha256 "caaf0de41089c8727356c91ef559a5ff718ec6cdbc06791375977723db1af00c"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22101c33731440d9aa8a2a9388a86f978db5c00461a9856ac80febc56c99972a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acba71a3c5a4d7b25eb7c68b1270472b78e1239608f1eddd84e93688ca0502da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f5e7cd2828ec8fcedde6435ca9d7fee4f3f839963176992a2afe113063ef2de"
    sha256 cellar: :any_skip_relocation, ventura:       "eaa68f7b57f5c6b3d649f9b47e883c94a7ba6d19fe726d75c15c5f36943c2bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aa3c56687889b1f7a0091bdaf1471d31aea97302d11428a10778a71eebffa2c"
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