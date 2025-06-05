class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https:github.comjoshmedeskisesh"
  url "https:github.comjoshmedeskisesharchiverefstagsv2.15.0.tar.gz"
  sha256 "bd74d4ef697fd186ee74b76f2100b16cb5ed2eb43d5e478c4c5481b659196d4d"
  license "MIT"
  head "https:github.comjoshmedeskisesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39c8317dd26af424b8a5373708ec2ccf46e9ca07001a9059f941dd2f8d63c6d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39c8317dd26af424b8a5373708ec2ccf46e9ca07001a9059f941dd2f8d63c6d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39c8317dd26af424b8a5373708ec2ccf46e9ca07001a9059f941dd2f8d63c6d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "11565cac4e96371bf526e2cf03088229e14c9163037545a127af19817f87f0ae"
    sha256 cellar: :any_skip_relocation, ventura:       "11565cac4e96371bf526e2cf03088229e14c9163037545a127af19817f87f0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b6ef898823271ed7926e4862504dfed4c64749c7e3cc03a2446a1b2491739fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}sesh --version")
  end
end