class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.23.0.tar.gz"
  sha256 "1ca7eba6265dd3af133707a794be6898e69e61522b9f506166d18191525607ae"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7656b15c1495c75bd2f390dff71fec84aef282af7cf0654c33fdebddb6a5ca1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ccc5b3e538670e701bfe89342a5a2d7e2f37335eaa9c9784c29cfa17c883820"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0d7d790a7e523a00115572b2364679e03029d09e3d0a7b86245a3290c53222b"
    sha256 cellar: :any_skip_relocation, ventura:       "4894bc4c9ce0f514cc7006a4fdc4c397a2800bfae93df2d6af00bd65465c6612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff8aa41e33fe8cfb582ddf1f3d929eac27ae0a4f4122884a7141bd492f32807b"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]

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