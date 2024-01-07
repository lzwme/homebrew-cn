class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.9.1.tar.gz"
  sha256 "77a611db8becd53122db7c609a5d419fc83f7938fe2b5154cc271ae8ac372c67"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfba2581e838120c91a260c160c925e764d946b6470a9c772a028a73620f0416"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee1a446c0e676d8d1ba6f1c992893f294788ea3b5ee51c1ffff19f2c3295bd8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e4ed78e43d1894a5a1f481c33e58b2c61b4ca0925c57ca9c3bbea6e9dcea7a3"
    sha256 cellar: :any_skip_relocation, ventura:        "0b0890a53151401103d37fabf712be7c065b30f25232dd2b75f320610ffe5e79"
    sha256 cellar: :any_skip_relocation, monterey:       "4981d261456f3b167035f021189518fef5b077575ca97ec4a4ffe82a4c6a2cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48e0ece483c97515eb3824000bfe46eb404b3da98291e653e59bf798619757a"
  end

  depends_on "dotnet"

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