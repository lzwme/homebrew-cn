class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.43.tar.gz"
  sha256 "b9feb900bdf79a5c542342f447f9a02b3d449a9fdace90f80cfb305568cc4cc7"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96f93467568039a53c08c8d49653b435307f388411349bf2f0a024b19520cecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d75183ec85a1a96931ae92fccaa885d035b0a375d7f078f4119a8f9f084f6f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9de97feccee8448e0192e3eac1fc2c404ec9b7c9ca958b8accba0c6469795780"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7b85c1f4ac7c9f021826745a3dd1ee5de0aafcb5d912302e5f0b40242d5e659"
    sha256 cellar: :any_skip_relocation, ventura:        "73ec9e456ab8bc7ea4f912afaaf0e9c5299429c02c653234f3cee022ba4fda62"
    sha256 cellar: :any_skip_relocation, monterey:       "1d5cd17b93723595e3443dd5f673bd1fb6e49c39f327646547a40e9fc158b3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de605f36f28e9fe1834ccd7fe17cb85c43d8d6e1d63e260368aa77b485591437"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end