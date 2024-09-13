class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.3.0",
      revision: "a9f07ef2eaff1d9172d616cd675af30e702b7a3a"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4b3f963da49832f2f5ca9178ee52ac3d6e334e4c5a3409f68ad4426b825a5233"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b3f963da49832f2f5ca9178ee52ac3d6e334e4c5a3409f68ad4426b825a5233"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b3f963da49832f2f5ca9178ee52ac3d6e334e4c5a3409f68ad4426b825a5233"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b3f963da49832f2f5ca9178ee52ac3d6e334e4c5a3409f68ad4426b825a5233"
    sha256 cellar: :any_skip_relocation, sonoma:         "99f16ad52048127f8e94ba7f9d78a5b5e9cf94e318c1976cc4eb613a679e7991"
    sha256 cellar: :any_skip_relocation, ventura:        "99f16ad52048127f8e94ba7f9d78a5b5e9cf94e318c1976cc4eb613a679e7991"
    sha256 cellar: :any_skip_relocation, monterey:       "99f16ad52048127f8e94ba7f9d78a5b5e9cf94e318c1976cc4eb613a679e7991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fd28635933cc70f506ea6e276db275c572e72a1db17aa748dfdc6c62f68f334"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath".goreleaser.yml", :exist?
  end
end