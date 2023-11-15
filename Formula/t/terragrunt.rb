class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.53.3.tar.gz"
  sha256 "d0512408e3823ffd51772c222140b01be62f9c0bcb616a31fa39ed626d2a6c01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9c2c9fdf5390bd114306ddecae17da10bbdd2ea755e4c5595cb6650e993493e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb54b2517002fd9b36f2399f503ff4312ad2040edce967958e49a213319f19c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8500dcc8c40d25ab551298c658d063a9de3dd396e337c531de9b49a8787e973d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e07fda93e977116449be4c57912bb27f91eafde5adacf723506a20ca54b8d759"
    sha256 cellar: :any_skip_relocation, ventura:        "eb3513c6959d5c82e5a0f72f0c57e3f36abb59dd372c6a031a1f817a09ee29c2"
    sha256 cellar: :any_skip_relocation, monterey:       "61713163f848ec952dfbf8a5e26cda8446d4e3da43fd6472257fd97dcd498c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b8710a7a21e5559f90fe01fa109e513de1d5632c8505a097ea1bc91bc75390e"
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