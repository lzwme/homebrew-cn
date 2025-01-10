class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.22.0.tar.gz"
  sha256 "e65aa2dae53aeeb4c6dbb8a4c76f64e485149aec4ea2949ae9577fa6dadb48e3"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c443d0bfca8a67eca4dab09d4da9a44250a33864dedbefa5a8743a74766745d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e0fac7a249e054d78e4d76afc97bf333d4ea5f68aefa3ebdee9cb5ce0925915"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a4e836539d650fc098312e82cf620c7efd4283a2854ef60ba985cd6bba6dc0f"
    sha256 cellar: :any_skip_relocation, ventura:       "c024dd283dda096755ad5f937ffeb66da21399d8b73e3e1cfaf0a223871a3571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84d0be6650caa82f8ef41c68bb6f50466feefcf97fadef990b202443d1c293fa"
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