class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https:github.comaandrew-metgpt"
  url "https:github.comaandrew-metgptarchiverefstagsv2.9.3.tar.gz"
  sha256 "9607983224da9706535f5b38ca4124cc439850acef57223cb02925ea9b168fd7"
  license "GPL-3.0-only"
  head "https:github.comaandrew-metgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9538fb2c28578522a79fb5a172207ba7a67e25635f44d7e6841f48f33179255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9538fb2c28578522a79fb5a172207ba7a67e25635f44d7e6841f48f33179255"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9538fb2c28578522a79fb5a172207ba7a67e25635f44d7e6841f48f33179255"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa74d5e0e846b2fd1be359613cc38a87238fc7ba3fe430582ba3d7463c94290f"
    sha256 cellar: :any_skip_relocation, ventura:       "fa74d5e0e846b2fd1be359613cc38a87238fc7ba3fe430582ba3d7463c94290f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60facc507e4b868b067f56d7755182f412253f3579a263d883a34cdbf72c5ca3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tgpt --version")

    output = shell_output("#{bin}tgpt --provider pollinations \"What is 1+1\"")
    assert_match "1 + 1 equals 2.", output
  end
end