class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https:github.commbrtgmailctl"
  url "https:github.commbrtgmailctlarchiverefstagsv0.11.0.tar.gz"
  sha256 "6a299e60cfd5e58a327d2768cb9ce791b87d2e8be5293d29a4f4919d00cca2cf"
  license "MIT"
  head "https:github.commbrtgmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee77aed19516c088c2d625ce4a0c235834e22b74092fec144dc1b48494f742ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee77aed19516c088c2d625ce4a0c235834e22b74092fec144dc1b48494f742ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee77aed19516c088c2d625ce4a0c235834e22b74092fec144dc1b48494f742ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe6d471d8f4fda9b6c6e2f39b3d09b70c745291150d982db48ce8e03792a988"
    sha256 cellar: :any_skip_relocation, ventura:       "7fe6d471d8f4fda9b6c6e2f39b3d09b70c745291150d982db48ce8e03792a988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60d4a9f72f8bb954e35ad8a7b31147f1f5f87fa3f56a18eaacc62b570fe1a399"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmdgmailctlmain.go"

    generate_completions_from_executable(bin"gmailctl", "completion")
  end

  test do
    assert_includes shell_output("#{bin}gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}gmailctl version")
  end
end