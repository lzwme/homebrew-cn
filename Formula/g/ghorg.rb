class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https:github.comgabrie30ghorg"
  url "https:github.comgabrie30ghorgarchiverefstagsv1.10.0.tar.gz"
  sha256 "ead1071c7d6d147578c2299f341a2089cb5f6901939f3581dcc408eb72e2f0fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "074be2e1b88005dc9a0c4a819f980887b0a964acc9f9b56d96e2b3bc2bf865b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "074be2e1b88005dc9a0c4a819f980887b0a964acc9f9b56d96e2b3bc2bf865b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "074be2e1b88005dc9a0c4a819f980887b0a964acc9f9b56d96e2b3bc2bf865b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cceb8d19dd63845b7bb4c81c2a3c44e7d23e2c10cea63840d09662c6b6f2d2cb"
    sha256 cellar: :any_skip_relocation, ventura:       "cceb8d19dd63845b7bb4c81c2a3c44e7d23e2c10cea63840d09662c6b6f2d2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ab03c8490af030eada3ef6fc5a21adafeadda18cbc468ff765977e6403de2b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}ghorg ls")
  end
end