class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https:github.comMightyMoudsidekick"
  url "https:github.comMightyMoudsidekickarchiverefstagsv0.5.3.tar.gz"
  sha256 "11c6f23c67c122ec6e1e0fa4cd7119f7e044186abe810e08ea97708bb78e0a33"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0966d3dcaf938faa0dc73f2e9d67f9d85a746f81e916c3546865201782284193"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0966d3dcaf938faa0dc73f2e9d67f9d85a746f81e916c3546865201782284193"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0966d3dcaf938faa0dc73f2e9d67f9d85a746f81e916c3546865201782284193"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4a0d4d6b5d011b8683ca90a030a3bf96ee83eb5e6fd4418bfe650b9a9edc7c5"
    sha256 cellar: :any_skip_relocation, ventura:       "b4a0d4d6b5d011b8683ca90a030a3bf96ee83eb5e6fd4418bfe650b9a9edc7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917920794d53e70a725d20a0bd6ceb772a3e8d8b59da27e354c806b5394dde23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}sidekick compose", 1))
  end
end