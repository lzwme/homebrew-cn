class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.1.tar.gz"
  sha256 "4f56dae7e4586829eb71aa4fcf7bda4385d8b78311833cd82224b9de18958d71"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52eab6c3ef3e36d56057d2967ab79bbafadb1bee90fe728c9494cae33e3b9fea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52eab6c3ef3e36d56057d2967ab79bbafadb1bee90fe728c9494cae33e3b9fea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52eab6c3ef3e36d56057d2967ab79bbafadb1bee90fe728c9494cae33e3b9fea"
    sha256 cellar: :any_skip_relocation, sonoma:        "c49d142a978b808b803ed6e9dda6a744972ac22eab9d7eb8ed0a7350cf5fc6f4"
    sha256 cellar: :any_skip_relocation, ventura:       "c49d142a978b808b803ed6e9dda6a744972ac22eab9d7eb8ed0a7350cf5fc6f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "020b6d83e5a4b376badb7cf83aceab36f9fdbc5701bdbebc2178e240932cf01c"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end