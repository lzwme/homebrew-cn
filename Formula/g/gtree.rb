class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https:ddddddo.github.iogtree"
  url "https:github.comddddddOgtreearchiverefstagsv1.11.2.tar.gz"
  sha256 "df5b3d859a5d1c7dc3a3f04fc84307be215dc1e511d9a68e0689a054083f63b7"
  license "BSD-2-Clause"
  head "https:github.comddddddOgtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc067b4c8d79634c4c2fcc74b6da4cf6bdf6e5f292864296c4f8c89e7c70ae88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc067b4c8d79634c4c2fcc74b6da4cf6bdf6e5f292864296c4f8c89e7c70ae88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc067b4c8d79634c4c2fcc74b6da4cf6bdf6e5f292864296c4f8c89e7c70ae88"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a2e3afdd53fe96b5d09e877093ec2d5262f606e80c591c8346b106bbbeba692"
    sha256 cellar: :any_skip_relocation, ventura:       "0a2e3afdd53fe96b5d09e877093ec2d5262f606e80c591c8346b106bbbeba692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "340997d6a1f0248af0f6db332dcc89564b0d050d344cc5c3d50fa7e8c9a1c333"
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