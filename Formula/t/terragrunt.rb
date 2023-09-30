class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.7.tar.gz"
  sha256 "bcf8ac79be0042810ca3d9ee7d6fe1f454af93a713cfac842c09ae4f6f96ce92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "672697d85ad79f1fc46c4b0d0ca5ae2621ef44db9b2369f89b6924d3c86394ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7f11a892b585420dd8983f19e7f0574962650d3cb300703176ed9c28c42c683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f324d506d6c1a6510200d3ffac4b901f92b3f918b3caa5583b3c10b3952bf77"
    sha256 cellar: :any_skip_relocation, sonoma:         "d76caf360a463093642628ed2d0167b82916df5b62abb7085a5a7e0b484f2010"
    sha256 cellar: :any_skip_relocation, ventura:        "54f7048d7cf8b6a4db41cd474608075479d9b714205dab2554a297944a629099"
    sha256 cellar: :any_skip_relocation, monterey:       "c6fa7336d36c14afba0685e6e1927aa3994979177eb404403ae3a4503cdda30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5131d7554406df8cb5e05db95119e8fd9bdde88082d7bcdb995afb1a350c86c"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end