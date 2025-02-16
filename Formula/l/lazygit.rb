class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https:github.comjesseduffieldlazygit"
  url "https:github.comjesseduffieldlazygitarchiverefstagsv0.46.0.tar.gz"
  sha256 "7157f8237953cf65fce02a5e662bdffb675f196cdf736b7ab6d24539b915bd74"
  license "MIT"
  head "https:github.comjesseduffieldlazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6934f0bf780958446878231b6fa18464ac986ca82eaed53020878c10804f6fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6934f0bf780958446878231b6fa18464ac986ca82eaed53020878c10804f6fe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6934f0bf780958446878231b6fa18464ac986ca82eaed53020878c10804f6fe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "244139a49f4397c69dcffb77eb1ed097d64350b0c88dd01ea6b8a7427cfcce9a"
    sha256 cellar: :any_skip_relocation, ventura:       "244139a49f4397c69dcffb77eb1ed097d64350b0c88dd01ea6b8a7427cfcce9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0852947dbd645392f15c7346b1cfa48042c6193ad78dec526d817c677529b9df"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}lazygit -v")
  end
end