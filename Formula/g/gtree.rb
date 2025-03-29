class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https:ddddddo.github.iogtree"
  url "https:github.comddddddOgtreearchiverefstagsv1.11.0.tar.gz"
  sha256 "3b7ae07dfbac1a58058c6f8497198d539db0cfa2e4fac589a129586e17660e93"
  license "BSD-2-Clause"
  head "https:github.comddddddOgtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccc1eac92571f7fbe0deb25f5964776c1e6d518337413c69e0f9e6a96fb78655"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccc1eac92571f7fbe0deb25f5964776c1e6d518337413c69e0f9e6a96fb78655"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccc1eac92571f7fbe0deb25f5964776c1e6d518337413c69e0f9e6a96fb78655"
    sha256 cellar: :any_skip_relocation, sonoma:        "8447bc1aa528e42507f80242558aee2bacf665172c1b9e31c682bd06c0fb8419"
    sha256 cellar: :any_skip_relocation, ventura:       "8447bc1aa528e42507f80242558aee2bacf665172c1b9e31c682bd06c0fb8419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21130a730bb31652932778b3520ce6cd9581ccb29f18bb72c1d7d1597fdb59cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gtree version")

    assert_match "testdata", shell_output("#{bin}gtree template")
  end
end