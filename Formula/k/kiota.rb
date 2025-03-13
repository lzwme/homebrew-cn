class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.24.0.tar.gz"
  sha256 "88ed74c096708c68f115fb57b852801426319cfc0a638fb712333e077a14820f"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "460bd10e61b58d5969a29ea77c483730d23d7e792d6892253e081e77b13a5ae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f38d8bc7ecb8d19cfed245b87c2ff61f0857b3c7bf6e7259d07648a3fc49bd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1fc8ec2245552d5dc43a04e38720dc63d5498cf70d26fead6134b41221cb351"
    sha256 cellar: :any_skip_relocation, ventura:       "81a31b126167040f0d2f8262698eb910bbe83069e377ffb90556e256d57c2e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0118b11e5689f7e46b16b220fe06c706e0f4b6996cd98681817025ccbd3098"
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