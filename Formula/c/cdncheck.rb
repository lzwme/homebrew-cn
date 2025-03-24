class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.11.tar.gz"
  sha256 "7f9b9389ef6eb0201aeeae34c5cdf081275d5768484c873b25d9a79ac50ebd10"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf4beb95e6f368b5bdb2c7743f42577b86545f243b0c46425f74f740cbac852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89cb126f1bbc968e24d352387b7c9de089308b72e412231e473dd6ac87b6c42c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18d40c634bd68cfea14910308e5678aa8eaf41c84ad073786ceb07422a5d5e5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ff772db0e7e99443ff43eddda5cc7d070b7c5f0d15310fd5d6f0c7068be557a"
    sha256 cellar: :any_skip_relocation, ventura:       "288f0c4659ea371f25820350253e1f1c399fcf2ec3b1c323641b68883db7d233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4015095c60e1c1efd7413da991837a24baee9cae75b368ee40d09a053ed94af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end