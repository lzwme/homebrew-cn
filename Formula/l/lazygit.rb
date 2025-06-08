class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https:github.comjesseduffieldlazygit"
  url "https:github.comjesseduffieldlazygitarchiverefstagsv0.52.0.tar.gz"
  sha256 "2d6b045105cca36fb4a9ea9fa8834bab70f99a71dcb6f7a1aea11184ac1f66f8"
  license "MIT"
  head "https:github.comjesseduffieldlazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f753dc483e5bcc8a65b14db075aa660598c5710bb058c5ad435f6cc0ab9f0a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f753dc483e5bcc8a65b14db075aa660598c5710bb058c5ad435f6cc0ab9f0a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f753dc483e5bcc8a65b14db075aa660598c5710bb058c5ad435f6cc0ab9f0a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6710caabb7d8545d399d263f1bf57d987cd937718bc36553e5707029516f5da"
    sha256 cellar: :any_skip_relocation, ventura:       "e6710caabb7d8545d399d263f1bf57d987cd937718bc36553e5707029516f5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a481b03b3c0853648114f28e39abf4cee7265da3e45f537f4ced5d28e9ec8dbe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}lazygit -v")
  end
end