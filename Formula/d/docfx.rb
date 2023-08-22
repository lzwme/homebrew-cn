class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://ghproxy.com/https://github.com/dotnet/docfx/archive/refs/tags/v2.70.1.tar.gz"
  sha256 "542ef0550d2155bf4268aed4210bbd56f110902b12d2a5d209f1a1e29d5df9b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d06adbc907510bae108ead21ef544ed2aa6d90ef9ffffa3b75bc3cc0cb10fa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fb9ffad2d6e3819178560a68bca9fbc93962eb51457dbe77655b258b2e27f70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee81ddef5a93904d9bcd190fbb6965f763628de168a98c830b5d644c2a29a98b"
    sha256 cellar: :any_skip_relocation, ventura:        "4e0757aea02babebe3006db545d5031311413f8c4b0f8f2cde943fdab9ac4d37"
    sha256 cellar: :any_skip_relocation, monterey:       "39096cd25d19aaf3e7846a034f08dfe424e04889bd0c640a070308d6200102e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6557147d45ac23542616fa571d55083905bf56694727ad77c6c19b071400c9ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c87401f27eebde8533cbbaf65d9bb566a912c3d0ff62847c60feacd9aefeff41"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https://github.com/dotnet/docfx/blob/main/Directory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    system "dotnet", "publish", "src/docfx", *args

    (bin/"docfx").write_env_script libexec/"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    system bin/"docfx", "init", "-q"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end