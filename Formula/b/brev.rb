class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https:www.brev.dev"
  url "https:github.combrevdevbrev-cliarchiverefstagsv0.6.293.tar.gz"
  sha256 "01bc48ba507a4bd0b4f38bcc8c30575feec9e5d34d11bcb6422b01f3e1cd9d54"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5627ed649c6a14f30056309e2337e1e7ab9a8f046d0bbd95eb1c377e08225d8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "116cb9ae7c7b4309ee16ad6bba9c1f84a8045d2af6aa8b5a6401bfd350a48f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26cd07a33d47201cefbce996a2c5a920157c193019bd0ec85c17b512d595647c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cbf6d728df89a62f6627323fdd904d0349454df1da3049181c41ac65e519c24"
    sha256 cellar: :any_skip_relocation, ventura:       "abe627ad9e6d435794f766edb68a71440d6778ef2ee667b23ea443ded57fb008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135a13b0c6a1019ed46e73228c91dac69674053de2fe8db2f3b90eccf9cc3d26"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combrevdevbrev-clipkgcmdversion.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"brev", "completion")
  end

  test do
    system bin"brev", "healthcheck"
  end
end