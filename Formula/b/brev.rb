class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https:docs.brev.dev"
  url "https:github.combrevdevbrev-cliarchiverefstagsv0.6.284.tar.gz"
  sha256 "5d29c178098db717453ca84d9ba96f1db55c9a42fb1cbbde3ad30968514250e1"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8818b2305f93ac1d45008ae8ac9fdd633c46f12f4cd8cefb3e14c21e2a741957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30bd5a4caf33ae2bf06a3dd6d527009936f2bb5193943d72e33173617f056ff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d63e9effe7cfb6fe41e9e938041e1f9ee997e5f7d5f27eae54f36157145320ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ea8085105193506c8cc999619efe0589b23b6662201b8ef6ab839214c58ee93"
    sha256 cellar: :any_skip_relocation, ventura:        "614fcd5eb93b9c85ce8f83c310364d7dd057234d597b1867e1d603c41c3a6081"
    sha256 cellar: :any_skip_relocation, monterey:       "8288cbe754c262c59ca22456d85d353ab1be6828980a7fbc91be6308f743233f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a38f2cd9b1605f4e56f96c6014b05914bb8fe2cb0476e8d8020b13b1564b168b"
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