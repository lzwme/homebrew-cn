class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.7.1.tar.gz"
  sha256 "1c09aa1ad024b22c9833c69eb4a51304e6e52f1ec5a6c2b64b71b0b45a317fe7"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f16400ab5442d3f3e1ab535be2ed434b7162be3ff18f82fe28fa67c453a9407"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f16400ab5442d3f3e1ab535be2ed434b7162be3ff18f82fe28fa67c453a9407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f16400ab5442d3f3e1ab535be2ed434b7162be3ff18f82fe28fa67c453a9407"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2202af7ddb70aac58acc8d6a53bf41cd8c07d7750c337017bc84c0996026631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4851a0566eb93aca4ee8c9dc4a82ec4971011ec0c1e7cde061b19b853fc0872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf00217705922c1d143a7c95281b9b2394bdf9ca064cd1b6cda53f7abcf9780"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end