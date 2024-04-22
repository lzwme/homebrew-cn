class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.4.0.tar.gz"
  sha256 "e48ca8f74fa66fbd233de73d9d86a51c034029fa49a51a331d7edec2a280e801"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa08124505e0651068c928d0b73d33eb9ead1017280499bf0e30422fe5e17e4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e77e9d4fad01e789d687e14982485a34a9f7445dd0cb50f2f2817ebfde9c07b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89594ac6ef5ca09dad036f104ad3fc02b95227e5e2dc6a55af3ea2b249d7a55f"
    sha256 cellar: :any_skip_relocation, sonoma:         "829179a8f003203352303d912b67c51e4446b12db839c53c49e3d88cacae4c1f"
    sha256 cellar: :any_skip_relocation, ventura:        "5d1265864a0dcc1ab92a36c68eee200bf2aea0d6c63ac31fc3cfccf730f81431"
    sha256 cellar: :any_skip_relocation, monterey:       "2746b051016510329e017a2a692520e99c63d3f4851ffcaa0a2e3f4e63b5afd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cfc7b77648cf81d63e18146e321b4383ba8606090dfc4df31c73771bc0e3140"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end