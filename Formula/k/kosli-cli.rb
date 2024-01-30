class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.7.7.tar.gz"
  sha256 "494b8286b5cde1b12e28893248c4464833a10dc5fc25c65c4d04bf538cfb4747"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "008b191b2119e81ce2a88e74902fc4c600df5d03c3a6b5fdd7c0a3500b02608a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f03835cc88dc8f13c1d2fe23fd63f26c8eb049cdede5400f51c135a26ee41e2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80e8cfe03a8562bdcb2d6e7d39ab863102da8b511e65f7918151b220ba678412"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ab3ace7f82637015030c4f0246683462605b9a6b9ec7f0acf9ae06503be7ae9"
    sha256 cellar: :any_skip_relocation, ventura:        "086ab50e593287e723cd74787dc379249d426871e59718bcb5f566d008ac520a"
    sha256 cellar: :any_skip_relocation, monterey:       "ebce5c05bf7a02e60d43da71f8d312b95d634f1c9b4a0a16d1bdec1e5efb45e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d28220f1f81723732d21190d7f36062bd2e46992619a427c9f31d74966142c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags: ldflags), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end