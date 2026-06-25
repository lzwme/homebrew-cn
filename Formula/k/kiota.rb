class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://ghfast.top/https://github.com/microsoft/kiota/archive/refs/tags/v1.32.3.tar.gz"
  sha256 "a33dd2071704712469055ae66dd4973059fb4090d40ebf6f48dee759f299c146"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c207ac7acb72cff7201de24ff91ca444e0a18dc83d356d26b945e0c044c8406f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcc53ecdf5062a1df8c7ecd63bf5e48aecdda2f76d0eb93194c1f18bb00a08de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef8285e5e5dbd1e8da4a369eae43a99dd8e4edb49124cd244c79d4f68548c1a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d69138b3f289baa11453c1984368a80c96cda8c6b6a3016eaa462972368036ef"
    sha256 cellar: :any,                 arm64_linux:   "2f1b11dc763ab39a7b47bea42d8d2b75f7346034976ec0b0551f4dd873506bd1"
    sha256 cellar: :any,                 x86_64_linux:  "3637fefeb8aa59ce9fbc1f79b8be2d42c8d2e5e8c5e8598f76f3f863240e7a66"
  end

  depends_on "dotnet"

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

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

    system "dotnet", "publish", "src/kiota/kiota.csproj", *args
    (bin/"kiota").write_env_script libexec/"kiota", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kiota --version")

    info_output = shell_output("#{bin}/kiota info")
    assert_match "Go         Stable", info_output
    assert_match "Python     Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match(/apisguru::github.com\s+GitHub v3 REST API/, search_output)
  end
end