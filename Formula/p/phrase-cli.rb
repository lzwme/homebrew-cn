class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.52.0.tar.gz"
  sha256 "6f62986a31e700c7fba8431df3421aa678571c1e942a7533c6b60371cb355fad"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53671ad6f0c8ebed4b7bdcf97f840572f8aa3906248fc137ab0db95140cb1f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53671ad6f0c8ebed4b7bdcf97f840572f8aa3906248fc137ab0db95140cb1f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53671ad6f0c8ebed4b7bdcf97f840572f8aa3906248fc137ab0db95140cb1f78"
    sha256 cellar: :any_skip_relocation, sonoma:        "c18d6db94264a1362b52c1ffee4aae881b81db2afe82a52ae4f3f14515d465d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ef38fdd9a4d0698207f8d6ac0e3873907d66e40311bb62dcca7fe933d1523c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9b306919074818ce3ca7d71ed48987b601d0f97d101888ba5e4bc80a7f0530"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end