class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.16.0",
      revision: "945b5453d953e36c7fcad8ff64206c021413271b"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83edd1089db7a525623e8ded57ad4826d5c1f9d7fd65cb1f2725ef134fd34d03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83edd1089db7a525623e8ded57ad4826d5c1f9d7fd65cb1f2725ef134fd34d03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83edd1089db7a525623e8ded57ad4826d5c1f9d7fd65cb1f2725ef134fd34d03"
    sha256 cellar: :any_skip_relocation, ventura:        "9b4dc407f3a8914ed517971d5bcca74740f63c23bb50a660925a721d72d1605e"
    sha256 cellar: :any_skip_relocation, monterey:       "9b4dc407f3a8914ed517971d5bcca74740f63c23bb50a660925a721d72d1605e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b4dc407f3a8914ed517971d5bcca74740f63c23bb50a660925a721d72d1605e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198978709afd1af538b264f307982d1dc08931e6739c3d41ca06b7e8f81673fc"
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