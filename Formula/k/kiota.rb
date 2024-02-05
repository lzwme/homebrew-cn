class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.11.0.tar.gz"
  sha256 "be2ff164d54ddbf5a4c57ce9f797f2367df2741c51885262ad6ae688abd5025d"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "145d1164364f1b6d80f6ffe906741317986979c5a91f5c9b3961bbd91bbb92f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6f3ae5626df96aff560e63ede8d11c67f9dd913eafb901bdbcb06e0bdc6e94f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8db8b9843ae197029bdd38f4c32e50bda202fdd280696c10eb47802e552d232"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cf5b7da321ec459d250d0876c0ae5fc98f352e4a70242422b2ef1b013668884"
    sha256 cellar: :any_skip_relocation, ventura:        "723bdcaa20c1cce22656c8ecd837b48085538a5cd3a33330afb90b35930ae369"
    sha256 cellar: :any_skip_relocation, monterey:       "5f9a381f77c32dba83e1047717105315c321167b247438c795cfac2948249157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3501addc8da549489a3f7c3d76dc96c29fdde56927523e31f3a149d2dd8f2edb"
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