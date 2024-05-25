class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v1.26.2",
      revision: "d7c23c168fa61d738cd6fba03a645071e174bba5"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e4d74ae84235c7fae09fa98a0d176f5fa32812d17a03f33a6703f62f79817b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ac61df41cc505d0f629e62e7715927f0d22db4ed3732553016625b887fbd79e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ba4c883af84ace0a9728e0f75032d1ca1c5c65fd5e0150c3ae33170431476ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e985e7e6cfd6d8c45bab57650bcbd6e10752b6874419f8de041642ec85ac691"
    sha256 cellar: :any_skip_relocation, ventura:        "769eb1fdbff427feacd14d25075823bc66009e36ef9ec9983934dcca38e2e300"
    sha256 cellar: :any_skip_relocation, monterey:       "14dcbfe7a8e3e04847885d07815254401115123fb9c1951c7df0002df4777c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a22dcbe8092698f6249ce12d239856edcd39f9568a4232198b62d40376d7bfb"
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