class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://ghproxy.com/https://github.com/notaryproject/notation/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f3f9df6fbd717cc169030d6527591d56fd37f0469a4a3b4c4e3d4c1ee0264299"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dca353ae6bc14a90bf43293e91b8ffcacb44eaa22863ff9839a111f40fab35d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4a1867f5c77d519b2baef9325cdf30f6bf09c598821bfd7e50d9c6068684634"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a81b706bfd194cba45eac778add9c55286b440517221890984030d722f112013"
    sha256 cellar: :any_skip_relocation, sonoma:         "f966bfbfca323c9de79c3605bc468d6c7149125f7859b28c5172877737117025"
    sha256 cellar: :any_skip_relocation, ventura:        "b13b1bf7642e40c45ee40e55888f5620dbd422147eff1e3d6dee5da418a83bf0"
    sha256 cellar: :any_skip_relocation, monterey:       "24f6f8118514b61e095c208aedd5e516aa366413142aca9c8ffd8a0ccc92c4eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631eb1a05d62397ceead6f41106d12b32a1c9af70085437d9d26a2d2340af229"
  end

  depends_on "go" => :build

  def install
    project = "github.com/notaryproject/notation"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.Version=v#{version}
      -X #{project}/internal/version.GitCommit=
      -X #{project}/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/notation"

    generate_completions_from_executable(bin/"notation", "completion")
  end

  test do
    assert_match "v#{version}+Homebrew", shell_output("#{bin}/notation version")

    assert_match "Successfully added #{tap.user}.crt to named store #{tap.user} of type ca",
      shell_output("#{bin}/notation cert generate-test --default '#{tap.user}'").strip
  end
end