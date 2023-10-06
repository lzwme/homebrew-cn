class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.26.2",
      revision: "7d155f39beb48e5ab3018f7248c937ddbadcd199"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6de8195871aed8eac725de3c0c8232236c6ca66d1ffeb8053b41476868d56f9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce6fc861d80e861180cdfd9954cde39e8012376fceb485091d306f0a14531d91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c24f8a5b910c565b69fb0dfdf04fe7d5d6cf4666f8021eecf009838016e56a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "64edfb86d9808f5f60306528b61b969bfcb8664cc44d0982dc7404802b73305c"
    sha256 cellar: :any_skip_relocation, ventura:        "f08c0ccd5e0a864792b17dd7bb5d4e9e8afb7a0fefc83575c8bd22e6ffd1f700"
    sha256 cellar: :any_skip_relocation, monterey:       "b23ba1e44c989e81290b75f7629e644f47f5406bb4d02104b574e535f6d062fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9034efaacd0dcfdba90479d19506b1d10b52b247835f6f27ba023c15324767c"
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