class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://ghfast.top/https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "894fb82922c0ad3fe36c691b0af1ed192f031b969c15fbd2f59c18c175bb38c7"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "990ab897f4b93ae5ecdad1cd3154c706a051c0a9e3ad359871839cc116633a17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "990ab897f4b93ae5ecdad1cd3154c706a051c0a9e3ad359871839cc116633a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "990ab897f4b93ae5ecdad1cd3154c706a051c0a9e3ad359871839cc116633a17"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f2710d447fe935c4fe22cb89a25e9ed80026f946ca16b8b2e88b3f6694576f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b05ecf4e125886dea5c9016d39d1d58348c9f0334f8db0cb51865b9dbf195264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed107d45bcc0b786ece77cfd659858c3dc762cb6ac8073dc9d0e9297310d1bfd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end