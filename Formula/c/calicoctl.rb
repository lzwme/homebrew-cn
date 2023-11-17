class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.26.4",
      revision: "6139b6dcd183f91e9a37f74547fa1a94475987fc"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7765b2599e1c19ca6b1963fa37c6617e9de1004b70f1eca33ad0a0b9ebf0bd7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "317c59854e0a8106e330474914e2c09f8477fea6c6165bde4fe1d4625420f5a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dfaa6f2eb25f760053d762bbdffac402cd79ee251cfd23af4f44acb5be8c4f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "85b012b3dadd86dff5113bb4506c032f98a3d19bef7c250a6500e0296373db97"
    sha256 cellar: :any_skip_relocation, ventura:        "62a43f312cc19ed1bc788d00d7cdac3423676b7c025b8b0b1fc682639b7be286"
    sha256 cellar: :any_skip_relocation, monterey:       "c80b229d8d313386652eca51d5eb6505469099efbc03dec79beeab36dfbecd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d50825fd3e60fb1bb5a15ddb6ccfd3517465e9cefd52b85292d667b6d0bdf9"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end