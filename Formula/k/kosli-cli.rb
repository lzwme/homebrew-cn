class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.9.0.tar.gz"
  sha256 "62fecb66b2626c763e6f29dcf77c3887e934e1977f89099f1dcfe4c37c215ce4"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e2bf022101a8b981a6e9fcb0754bd9f0dce084a8d4496c4fa74f10899138e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5716b591eed2f1d294194371577c4fd7d9721e653c4c40787c946d74c1e6c048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f727cae948cea8fcddc8f2063b2e0f43f3b1add75848dfd83e4f3d8e1ca2c7ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cb8c02ad9658eeb6c3a5c9ce44f70f0c18b0d48cf6b6f22321da55fb662d49f"
    sha256 cellar: :any_skip_relocation, ventura:        "24e63291c13ed9a8c470bdc5845ced2004d55ca826bcffc683dd0b77e9bcc51e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e0535eedfe9f1e4187c425365aa108143a1d9869a5e7dcd0b06f97e6f2f00a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9877d6e97a077b9e82ec09e8114491b29692c4cdfe987c1135ef1ce0c5936be3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end