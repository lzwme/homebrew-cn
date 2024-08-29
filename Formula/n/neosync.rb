class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.57.tar.gz"
  sha256 "b6926f3ff985adcb5822ff51b23c08baab2d730d62ff0420d67f02a7c6739231"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49e76176b7c36a102b5e66426e148d285eb188f07ebd4e2e8e75c288597c7395"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "600056f09711609cc0f8659d6ad96b55a93cd1fcc304064498c1d03017612847"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1a1f9c478b2719ec627f8a28121bd2c876f02788d90a1151cfc151926ad0296"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc87c260127d148e9301b8624886fc9646e423f406eedd527626a50ca0d70c96"
    sha256 cellar: :any_skip_relocation, ventura:        "f152630186be610389786f5f5a360745659278ddc3f2bb1c12b92d913443ed5e"
    sha256 cellar: :any_skip_relocation, monterey:       "108657175f2f67b8f8cec6d2494f825c86542d785a4ecd6411e0e5a977afa5c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d624c638396441c539d450037bcc28a00f9ec0aa9e48044184ba46720701c54d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end