class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https:github.comeditorconfig-checkereditorconfig-checker"
  url "https:github.comeditorconfig-checkereditorconfig-checkerarchiverefstagsv3.0.2.tar.gz"
  sha256 "c6613d3f091c20a0a873cf772280681a30931989068c561f5fd6d89466d43ca7"
  license "MIT"
  head "https:github.comeditorconfig-checkereditorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55e7f299dfd9c59bf62ab9da5cf955604b0dc4ed8a93b0be2ce6ce79d025f703"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55e7f299dfd9c59bf62ab9da5cf955604b0dc4ed8a93b0be2ce6ce79d025f703"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e7f299dfd9c59bf62ab9da5cf955604b0dc4ed8a93b0be2ce6ce79d025f703"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4c1a4bd75d2ea57f7b440e992b595021b38a51b38070db40954e1e943c56c81"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c1a4bd75d2ea57f7b440e992b595021b38a51b38070db40954e1e943c56c81"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c1a4bd75d2ea57f7b440e992b595021b38a51b38070db40954e1e943c56c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dd5a9b70a7042a97ce1ed8374ddaf7d2a8bdeef436a980feeab0c268b0c42b5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdeditorconfig-checkermain.go"
  end

  test do
    (testpath"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin"editorconfig-checker", testpath"version.txt"

    assert_match version.to_s, shell_output("#{bin}editorconfig-checker --version")
  end
end