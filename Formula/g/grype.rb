class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.97.1.tar.gz"
  sha256 "c5019e568378f851bb45b90fc53af470ec7be0886b3d62f404dc51630487b510"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f07235aa5746b6457cd14f0eb9ac4e0e5ea2c8cace93613923b6c27704454a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed88f05f5e08ecf3bd47e47bbac5b859ca43fed278d9e8703ab160fbb5b95fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d11e59eb14293d186171ccadef17ccb5341ab9b28fd4490d2fdc80fe5b0e1c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dffd6bb26fc7e4b28cc7913e6f7b6db6d5cdd192bc9a63f3210fba6109b297be"
    sha256 cellar: :any_skip_relocation, ventura:       "b92e11df8f302c1b5a4af629ce4a5722275dfb90c57dbf2cd702ef8265b81012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04dd1bc43503c75f8ec2b3dc82226bea6ff4965a0ee3c6b2b7024175cb9c16f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d45ecab40c82d60454b676fba1fec500a5384ac0759d4f6643ed1aea2fdad98"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end