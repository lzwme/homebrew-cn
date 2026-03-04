class Dry < Formula
  desc "Terminal application to manage Docker and Docker Swarm"
  homepage "https://moncho.github.io/dry/"
  url "https://ghfast.top/https://github.com/moncho/dry/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "60fbedd4c416b96c87ecd2c88c9a509433be53bdd6737345c9d1c62f024d4684"
  license "MIT"
  head "https://github.com/moncho/dry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9e54dcd0b3f732bf29cc3499f4be6d21e1c6f25d01b78852945eb6cff355965"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9e54dcd0b3f732bf29cc3499f4be6d21e1c6f25d01b78852945eb6cff355965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9e54dcd0b3f732bf29cc3499f4be6d21e1c6f25d01b78852945eb6cff355965"
    sha256 cellar: :any_skip_relocation, sonoma:        "5346f0731d3baa4110e54010fb80399500cb512bd9fd4945559bd04b42319ea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2339bd2ad48b74725e9e3f04b2028d04384c0f35b61960646df115d5083fb6ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3b2a9b9b7589770258064a3769f7a5df2e05bd37cf581a068a50db1ffbac63"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/moncho/dry/version.VERSION=#{version}
      -X github.com/moncho/dry/version.GITCOMMIT=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dry --version")
    assert_match "A tool to interact with a Docker Daemon from the terminal", shell_output("#{bin}/dry --description")
  end
end