class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https:gomi.dev"
  url "https:github.combabarotgomiarchiverefstagsv1.3.0.tar.gz"
  sha256 "bd7441272c6ac1ae6c3fb378c4fe1bdf5f9c12995eebc2cbacca3da8d7906c1c"
  license "MIT"
  head "https:github.combabarotgomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d58341b9da9c7e871ef6104378297566160b21df5fda12da2186435cae06110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d58341b9da9c7e871ef6104378297566160b21df5fda12da2186435cae06110"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d58341b9da9c7e871ef6104378297566160b21df5fda12da2186435cae06110"
    sha256 cellar: :any_skip_relocation, sonoma:        "23765b3744d1681ed967a44757214753a533548a73165531c657d08593bbfd47"
    sha256 cellar: :any_skip_relocation, ventura:       "23765b3744d1681ed967a44757214753a533548a73165531c657d08593bbfd47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9644480b083cf3a43b0e75ac3bcfc98e65159aeb82e12191218cfd0575cdcd3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gomi --version")

    (testpath"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath"trash"
    system bin"gomi", "trash"
    refute_path_exists testpath"trash"
  end
end