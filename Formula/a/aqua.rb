class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.56.0.tar.gz"
  sha256 "5c6926f50150517ad3c8931921a2bf8f0d5c8947a81a14b7582ca4a1b4e118a2"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "723ee02369126f5f494e3696b2dc24821da8f74d12311c9c14876fdb6f7d0db3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723ee02369126f5f494e3696b2dc24821da8f74d12311c9c14876fdb6f7d0db3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "723ee02369126f5f494e3696b2dc24821da8f74d12311c9c14876fdb6f7d0db3"
    sha256 cellar: :any_skip_relocation, sonoma:        "259da341d4675574e1ab2b33f07d6a94e1344d2ce48133f5f76153a083f204a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d29f976a5f39372a692ed74d93ebfd947169e4c1b92c5f27bb9e9a49d92973bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6255a1ec37a1efb99adef4e173c6548e97a21a324aef2a1a89f00e9cf7659ae1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end