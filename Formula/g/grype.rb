class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.91.1.tar.gz"
  sha256 "4aab5351f37853e59980fd2a9877988197adf2c916e6541ce287158b4db2c720"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94b3629b0fb8f036a3c2a478352b5a781d20fa096879ce242f64b6bb484c9ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85c93348e4a3a1d196fdd63a2ad5066822f0fb2572c67eef42d41515285614af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "386d0c5ffc14c1e77f6f742fabb5fa1a80443da74b4f97d09e11fefe5877b830"
    sha256 cellar: :any_skip_relocation, sonoma:        "164c85529058a9d31293ed12d0063739410918b0f61eb9df16668111141d205b"
    sha256 cellar: :any_skip_relocation, ventura:       "65598c9e0c4e86a5d2c8a2e9906ac7109504910d0609fd9e661bde5525bc1de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3b4b43080b2c006b5c2fff1d565334df54cc164834777dd9122fd7c8895cb15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7086a7c063787dc8c2366ebed34f150ae53e60e1ecc493ad7c736c2549de5c7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end