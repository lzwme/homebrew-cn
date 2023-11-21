class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://ghproxy.com/https://github.com/dotnet/docfx/archive/refs/tags/v2.73.2.tar.gz"
  sha256 "00101c1db47fc2b143ad6247819e1b4a6cbdc54eb0b642020d113e0440858a2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4a0c1918970f4580b98d7e37a929ec4af95d1154a1951daca3014a607aa2fbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a551012f2ecf91f8eacda940ff31dab11bd93f58371e632e26f738b779fcf6b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95fd88064e01106a3ff60d053a3d9a1348e36b787f176c1f23af7f1ec41f3645"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a6926b3ef12122a24f690a56720cf0800b330c03b7b2269ca7b337506b1483"
    sha256 cellar: :any_skip_relocation, monterey:       "ea24e833d3b910a8b9520fe3d89b492ed575f674cecaa6860fabedfad6811fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a329c860364a39c7644e69b24643ad0fef4c25c094c89bb084ab2bfb8e09a3b"
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
    system bin/"docfx", "init", "--yes", "--output", testpath/"docfx_project"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end