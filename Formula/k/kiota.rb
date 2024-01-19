class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.10.1.tar.gz"
  sha256 "f0daa8124c764592e0758449b0e141fe2414cc224a8a804bfef625b8b76efc14"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc3f04c1bd8d84da43df2aba29fdf77c4700c938e229af30ae387a00a7034429"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f55e922ff7b6fce268e1822b30a07234f00b2235cc257728ef0833ac897e97cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92aaf2908137aa6b6e3c5b694049d64d5fe1c71812cba9636bb823a9873f766"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c94cf03da2bead4a8975f711e3c9c8e1cd08006822aa72e396dba67e02a0811"
    sha256 cellar: :any_skip_relocation, ventura:        "6019e94760933c0dc93b44140e3b1fcbac8764236f08236df1c39b4da466f29f"
    sha256 cellar: :any_skip_relocation, monterey:       "bc01624cb067e609eaaed61d5db339961bc63b2dee3a2e84ff7dd9695719501f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c460c54f63144332732ebc14bee7df1e891ab8e7fccb5795b2a2daa6d5b8debc"
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