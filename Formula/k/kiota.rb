class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.22.2.tar.gz"
  sha256 "92b93218a283831b70e1ccc1ab92809fc2dac6746328d6523272737727eb70b9"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d175f6451ef92b61f231c900bfb9356d966cbf8c0dd4f2117e9e3b0d891958ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc1ab1ef8521e6f4a4fda8aed7a5669973b7c85d37f644732466baebdc16f624"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "810315a80d7f85d16a20cc3642a4363dac8a287593016337f8162ce89149ccd4"
    sha256 cellar: :any_skip_relocation, ventura:       "6236f3b78de34c99df742c3e8e67e4272ef734353f53855d32c0e61ac5ba82ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e86da2831947692ac913159c2c0856e9b1145b4fe25fc1228553d165a462fed3"
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