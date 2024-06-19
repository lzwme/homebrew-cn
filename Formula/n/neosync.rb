class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.37.tar.gz"
  sha256 "dac34815ad96ef7a6b942aea2ad193253486c595a39b2fd1613f7bd28e5eab17"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d57e8beca69a5dcba638e40efcb8e7628d53837bb4d07ab81544fe31b825cbed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "579bf824dada42cb7fc17cc4204ab8a44f3be7fac30280788bd99ddb81031c5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02c0950c60d8a1e7828381061abafefb8da8bc05c4261e164a03ed7693b93019"
    sha256 cellar: :any_skip_relocation, sonoma:         "96702f908172cf0e3d646a8e6075c4898cfe1f73314ec1f99dc25d736c5f48fb"
    sha256 cellar: :any_skip_relocation, ventura:        "4535ffe75309b3f9e81de5beaab425e543a0e66c6317f546189010c64bbe7da8"
    sha256 cellar: :any_skip_relocation, monterey:       "886e726b35c565f482c3b901cec836e661951c859ce242f8cd50b3ddb6f64dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89933949f763eda6e94b89b90f6324e1f498a241b92596e7adc6c350e370e589"
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