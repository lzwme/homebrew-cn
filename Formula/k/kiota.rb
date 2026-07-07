class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://ghfast.top/https://github.com/microsoft/kiota/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "e01bfe6f270aefded29f7e56906f4c964957fe49bacf0df4cf29a1eaf1ea5d29"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df4226b0b4daf6dbdc85cb33c818b1a0f6df17558fe655961d7464bac14745f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92f5ce19aeeb9e6d4054826ddc84a88dc75b64e6ded2dfe0af1969a1b9bc511d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0e50d452973202a2f1184f369764e030e23f769e578cdcc32004747dbcfcedd"
    sha256 cellar: :any_skip_relocation, sonoma:        "82db3bb1be7e083ee7ba44edffce107e0173c4950e34c351c760df2539818d10"
    sha256 cellar: :any,                 arm64_linux:   "1d9afd05231adba3d01cd7ec18d47b03ddac37653429e74d733fa154db39283d"
    sha256 cellar: :any,                 x86_64_linux:  "690b71360219447f7e6af67835e332b89f16f11266d9b9fe2abfbaa59c1e41ba"
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