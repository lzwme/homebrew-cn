class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https:cakebuild.net"
  url "https:github.comcake-buildcakearchiverefstagsv4.2.0.tar.gz"
  sha256 "467158d7f6455f4dfc97a9ccfd7688c84531427c7089ad83f69b09190892d4a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a6f6297c1432c5e049759e27aa4d33cb62c38013feb4af1faee7ee204eea8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5843f082902a7684078be97fe4c3a2ceebb628329bc7f31205094c1c6a08d74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "388467b61b9804d9c6a1134e7a584e4cfb176fe5af16e754216e5706458d5a78"
    sha256 cellar: :any_skip_relocation, sonoma:        "374a0d5c728f47ee1c3d5f832364caa3cfa70f4f0cdcae205cb046e17f6cb2c4"
    sha256 cellar: :any_skip_relocation, ventura:       "3cda4eb8413d6a4513d0bc085abfd89ed502c79efd71d903dff76e3930ed058c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4279a9392db8d794023860f45309380d7767b2f70cdf27398e5d0617ff160486"
  end

  depends_on "dotnet"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

  # dotnet sdk version requirement patch, upstream pr ref, https:github.comcake-buildcakepull4377
  patch do
    url "https:github.comcake-buildcakecommit92193becffb09dce10fda010a0de03f941919739.patch?full_index=1"
    sha256 "257220fb97858bd80c561be5d342c33eb21709cc76efefe9f8a0a3703e1cc329"
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
      p:Version=#{version}
    ]

    system "dotnet", "publish", "srcCake", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin"cake").write_env_script libexec"Cake", env
  end

  test do
    (testpath"build.cake").write <<~EOS
      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");
    EOS
    assert_match "Hello Homebrew\n", shell_output("#{bin}cake build.cake")
  end
end