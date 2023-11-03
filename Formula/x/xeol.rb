class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://ghproxy.com/https://github.com/xeol-io/xeol/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "3db90ee4b7bad5a9c9703e2bfb01712d226554f6bd1dae21db88184d6f198159"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d36121533da85bacdc7c7bd7dc68dea1f3b7a089cfcd61ca8a33a09aedae20a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4189ab135fdce8a0f88951262a7a988749ce562a09b6c91d95dc6ea57bc740ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afac549676368855f648d8093b460f90a1e92553053126e8fe16c9bf24079b6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d89f3384d747e261e4e87635be4680276381b408e91007d4843d82d52045f27"
    sha256 cellar: :any_skip_relocation, ventura:        "3864869a80ac4825e3fb86ec5edbdda17ed955f50a55bb0db7c055d6b532ce82"
    sha256 cellar: :any_skip_relocation, monterey:       "e9587e2a782baef1a9025eaa93c51f0339a6e8dee8fbf36ac61c6096072a12ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a17aedb8031a89711195f30a09a344ec46e3a0ce49547b7799c122e4b0e95526"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end