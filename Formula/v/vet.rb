class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.20.tar.gz"
  sha256 "2c44f90f4684d17018b636b9f7074cd7129eb6cea3592bd66b47f49a110c3d53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c55598ac032772d6d4eadddf6e7d88629b28a203dbe2b288584ceef055dc22c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344c78effe6e0273ce458eaa4e30becd0d977c12830212167bd1f55d1b21ec2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f934ab637b5250a01ff73ee9528cea8e53edd3c57f2aeac92aa681799051f22"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9914b9bd12b0e41564bac56e88174c6ca374b864518a62d3d02fc515ee77bc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "545e6c9f5bdfa6b265bef7ffedcf36ef9ca8c06a241ef2f82dda787896f82a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1b2cba8993f936ec82994a856ab314a14193581bf9b58aeca060907376fe70b"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end