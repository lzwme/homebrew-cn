class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https:www.projectcalico.org"
  url "https:github.comprojectcalicocalico.git",
      tag:      "v3.29.0",
      revision: "26c4c71c76cafea610380a55ee4ae45e09a8215c"
  license "Apache-2.0"
  head "https:github.comprojectcalicocalico.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d729c60fb3c90ae5ee472cd3e990054b80e9e7ecc794472b16fec460cd6f2be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d729c60fb3c90ae5ee472cd3e990054b80e9e7ecc794472b16fec460cd6f2be9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d729c60fb3c90ae5ee472cd3e990054b80e9e7ecc794472b16fec460cd6f2be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9ce0bf7785c77f67df9206e25cef31b89b2c57aaac862fe62450a3fbc3ab87a"
    sha256 cellar: :any_skip_relocation, ventura:       "b9ce0bf7785c77f67df9206e25cef31b89b2c57aaac862fe62450a3fbc3ab87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a13207bd8178994cf8e30998ec8aaf0b58b5bc71f0ceac29243b0921ad7d45"
  end

  depends_on "go" => :build

  def install
    commands = "github.comprojectcalicocalicocalicoctlcalicoctlcommands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags:), "calicoctlcalicoctlcalicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}calicoctl datastore migrate lock 2>&1", 1)
  end
end