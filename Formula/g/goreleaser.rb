class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.22.0",
      revision: "6b65ea5ca18f9ee2de48f2ecc914a617741d6b14"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "142712e3f08d1c65e2569b77a3f493640ace9672404a5f4bd3556fbfe6cca5c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "374c73088c789afe35da3217496068e9837c9a32efee8d85241bf2df08acb6d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b79e233eff89a928a8bc2573bc4a0fdef903bde555a80c28d79bfc4bd9ecf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d7aa0e11b38ee7b191181d26c30e851b2dbb15cd89b8e930abd778b96fdf1ba"
    sha256 cellar: :any_skip_relocation, ventura:        "599e80a9c90cd1b8b5a5a67a37a6d528dfa08bd069153302ad2be9807747dd1e"
    sha256 cellar: :any_skip_relocation, monterey:       "9735ec92b37a86287d687d0385ee871eeb1f87e45ab9406e3a128676f666cc70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddfd1bc8d18db3fedf183a5827588a9fe7fdac25115a1b18e415b70cfd9c090e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end