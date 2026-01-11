class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "085995a036e88de536c0b1286b093eb391f73e33cf5e601ef85393d1b93dff21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a15e9420d9c20d35aaeb7f70784cf3144809065fb33bab69ad07f612eeeecc82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a15e9420d9c20d35aaeb7f70784cf3144809065fb33bab69ad07f612eeeecc82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a15e9420d9c20d35aaeb7f70784cf3144809065fb33bab69ad07f612eeeecc82"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5a8e268a1a1392aebf3b60c188a56c09021b82af570e6a30734ca7391ed7ffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f2cd405cbafab52b165b688a0b560ac562368a395b6083dd94a03412b479eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb0ce4fe972d506d1328f33b61344703d49976547b76971c2f9f6b2f6fa4017"
  end

  depends_on "go" => :build
  depends_on "beads"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end