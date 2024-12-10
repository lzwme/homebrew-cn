class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https:github.comjesseduffieldlazygit"
  url "https:github.comjesseduffieldlazygitarchiverefstagsv0.44.1.tar.gz"
  sha256 "02b67d38e07ae89b0ddd3b4917bd0cfcdfb5e158ed771566d3eb81f97f78cc26"
  license "MIT"
  head "https:github.comjesseduffieldlazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8faac025e1c21936ca7bdb7d5a104317386a49686550c3fdfc8cff9c79e1983f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8faac025e1c21936ca7bdb7d5a104317386a49686550c3fdfc8cff9c79e1983f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8faac025e1c21936ca7bdb7d5a104317386a49686550c3fdfc8cff9c79e1983f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0070aff6b1915fe84cea7d5211ed63ae28e7dabc55eba1f6282f1eaba01c4401"
    sha256 cellar: :any_skip_relocation, ventura:       "0070aff6b1915fe84cea7d5211ed63ae28e7dabc55eba1f6282f1eaba01c4401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea460585abf0884e87f46c3d746c7904d24508b72b2c7317ce653d93d9b0c56"
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