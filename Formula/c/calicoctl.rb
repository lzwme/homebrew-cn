class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.26.1",
      revision: "b1d192c95c89288e163038c5095fd23f9adfb8c1"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0418c7510be4f6ed8d28ad1b811bde7d6dd52ba472acecc048ed4de4a4d72a84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fa69e5181de03817715d8a49c5a61d183df6cb8f10098cf1ab56ca0ed477fb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa69e5181de03817715d8a49c5a61d183df6cb8f10098cf1ab56ca0ed477fb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fa69e5181de03817715d8a49c5a61d183df6cb8f10098cf1ab56ca0ed477fb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "653bee4cae8101e6e4f671d2a9ce2836a7dd6ad8e129a82e93e2b7b13a6777f6"
    sha256 cellar: :any_skip_relocation, ventura:        "422e2d7aa8da5fd67a18096608bca4bd15024135b1e08c38a83926b9116de030"
    sha256 cellar: :any_skip_relocation, monterey:       "422e2d7aa8da5fd67a18096608bca4bd15024135b1e08c38a83926b9116de030"
    sha256 cellar: :any_skip_relocation, big_sur:        "422e2d7aa8da5fd67a18096608bca4bd15024135b1e08c38a83926b9116de030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65473f51db676f2b47a612aaeaa76c2f102117b127f4307ffd0ba7ca0ef749a9"
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