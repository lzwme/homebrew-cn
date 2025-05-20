class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https:github.comtilt-devctlptl"
  url "https:github.comtilt-devctlptlarchiverefstagsv0.8.41.tar.gz"
  sha256 "39864b28e15e08cf5db41fce0a4b3d9476bf670132d9d101a9db3ca2aace77cc"
  license "Apache-2.0"
  head "https:github.comtilt-devctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "349ba487b4ca419d6687d85032e7ba711724fd30c37f50a6e87c57a7a264517e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0c0630f8f5749dc562df2067409f588cb47eb849db9a4b8954e1cfff02a0912"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bdadd4bfba8373cf4b06563b4029678c463db529f3ca5edba2e1b8f329f8c46"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aac055745d03175d0122d022a65b39d52b8260960bc324a7bf4adfcaa08d1b4"
    sha256 cellar: :any_skip_relocation, ventura:       "a15fde30edabe0edc584dd7c3f804f1a24d501171b3dc910318adefd1fb47594"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8431b2f47707b07ffb8de7472f2f439a92228ec169083d93597a8e72cadee2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d9b1c826144f4a02d673ac0c752a4f2894d9ae7a0abe0d94760e1e287dcb65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdctlptl"

    generate_completions_from_executable(bin"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}ctlptl version")
    assert_empty shell_output("#{bin}ctlptl get")
    assert_match "not found", shell_output("#{bin}ctlptl delete cluster nonexistent 2>&1", 1)
  end
end