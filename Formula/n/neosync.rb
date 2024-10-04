class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.74.tar.gz"
  sha256 "3b2cb088c629a912ed48cc311c0a465b6385598a27209d23cbe1305eaa004408"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be32d14b66b44f95f1be6d89ab016cbd6f3b72a9823debd09e618b084c245425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e133d26c32a71cb93c23f8d5288bc728ffd4eea6a375b12115c3843a42b87f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75ffd3c4c17eabfdb065a3b5233049ea423a9d102d57246cff96a98327f52fe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c6bf1f2924bda790c8fe682b29005bc8993aead00c8977fd2a06166d402b24"
    sha256 cellar: :any_skip_relocation, ventura:       "2caabff69571dae5cf9ec285456d0b96853f5676533b5986dc7134d36db3df49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ba70a7e5ba29081589aa9ba150369b9a1b1c7af6dafa9ffd610001fb508a2c"
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