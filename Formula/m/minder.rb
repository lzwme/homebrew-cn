class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://ghproxy.com/https://github.com/stacklok/minder/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "664d26dc4d8bd4df248ba0f5a81f2b69398083cbc042fba80cbf0edb23245721"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed9f3f29991b861decec3010d516972a3616e37d13d55bef6753c1d28140aea0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5d8d33005181abaeef7039a01582947574c97b65fb72f335392a9dc3ff364e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0037ba6795847452168c48b13471fe6334f45949edaf7abab718c74f1485de5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9bd9bc76a956e77816b4a9aac89ef3dd26f906215e48f0384a3f77a8e515af0"
    sha256 cellar: :any_skip_relocation, ventura:        "5b6e598d609655450853a17e477f72c0b700933191db9ae9778a1ff0f76793fb"
    sha256 cellar: :any_skip_relocation, monterey:       "79ab56aeba194a8f7c61410698cc64c7559ee2527b345396114917ee3adf47bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab105ff90117756cacc69356b7ae7cc8c06b4a032b716167d817ad2174c8e221"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 1)
    assert_match "Error on execute: error getting artifacts", output
  end
end