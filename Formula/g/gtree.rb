class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https:ddddddo.github.iogtree"
  url "https:github.comddddddOgtreearchiverefstagsv1.11.1.tar.gz"
  sha256 "ff972f542d96d16da9799a435ec574276f507e3e24aa02b5a25cb675d403c2ab"
  license "BSD-2-Clause"
  head "https:github.comddddddOgtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f895f87c049932d2f788a07c58add5237e82f557f375a6d541dfd32cd28924fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f895f87c049932d2f788a07c58add5237e82f557f375a6d541dfd32cd28924fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f895f87c049932d2f788a07c58add5237e82f557f375a6d541dfd32cd28924fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dca043c572092041905dac692a543d50978390669859bc4809f3cc5cfc24b2c"
    sha256 cellar: :any_skip_relocation, ventura:       "6dca043c572092041905dac692a543d50978390669859bc4809f3cc5cfc24b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "479c86eef5f7e223df5b43500096e133460db6465ea695157335f9251003967f"
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