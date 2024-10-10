class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.19.0.tar.gz"
  sha256 "39d7b64a6da36fd34ad887159a89640c7f2bd3bc921b8c787480374f04628f66"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab074e15fdae5c836c81ae19c8e339150947c82a4e1efc639456429ec2b7862b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10f7f7355a83251ea704c4c14243a1e3ddc22bd49d38eea5a553fd1ca587e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10a391964f4a7b146d9db31e7ae4ec462318fbd596b6fb39d1e258a616a1b0de"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0bc1e4294e0577800927e03d862875877093f9fae7db4e49d2d885c6674599e"
    sha256 cellar: :any_skip_relocation, ventura:       "330d081563bc910d265c8865827f44413d331785c8d1afea2f6cbedc059e59e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c093b4380d75606e739e11123632a8c943ac4f5ff42ef83c6d4785d9c71bbdce"
  end

  depends_on "dotnet"

  # compiler version mismatch patch, upstream pr ref, https:github.commicrosoftkiotapull5548
  patch do
    url "https:github.commicrosoftkiotacommit13f564c59a29db31339e587d1d788fba433978fc.patch?full_index=1"
    sha256 "5c026bbf483d9e8053c6b89d9815308dad1ac27cc8bb16f711ce5b6648a80cf8"
  end

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "srckiotakiota.csproj", *args

    (bin"kiota").write_env_script libexec"kiota",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
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