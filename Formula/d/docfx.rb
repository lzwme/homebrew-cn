class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://ghproxy.com/https://github.com/dotnet/docfx/archive/refs/tags/v2.70.2.tar.gz"
  sha256 "3fbc18eac4831b87d08303a33020d698a813908a750635a2981c7afd05f853f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80b6a7ebbec9ab5fa072688851f5bb9966f38ff771a3e6da6a287b6b696d8540"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a503d24805b4b9195861562e2bcf78942a23642a672f24c7b59d446e124f8351"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d93356dfec6eedb3a1f428c49dff0dc7c58fb2a6d2ff2a787b3322927b1060f1"
    sha256 cellar: :any_skip_relocation, ventura:        "b903052aff0c648cd023b4c3177df2cf04d1b593a290d67b40c343dac63f0deb"
    sha256 cellar: :any_skip_relocation, monterey:       "66d657448636f862abb9285859608d697d5ce57bb287aacf80cae752d249c2e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7a522cbbddb5b6622073cbf181bda6dc30bbe4bb423b31bec2a2c9610d483c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9c7e0112580927990f4cbfcc5c4d2555d61c48945a570eb1ea01c692e297549"
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