class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.8.7.tar.gz"
  sha256 "0d90d5fb2f0c1e01fd5afd998e6c70d10876441043e138aec842d4a1a1338c66"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a771c5e649f94e13494b6b5c077c3ebeb8c3947dad8be7401da3cd6734d78bf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19c204616b35ef0317a737d3ba7ccb5428e58640bf786069932d4b2cff7beceb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d37951a56dd9a36be308cc9ff8443facdc0be8b8886dec093dc78cc85b6570e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fbc769a950c4d48de7fc3d57ac1434336f7333e4e3a7b832f725092d2694e02"
    sha256 cellar: :any_skip_relocation, ventura:        "fbe9124a318e8cea7be42426b99173ad2713ba3460bfc95d02d9ea634e39ad01"
    sha256 cellar: :any_skip_relocation, monterey:       "2fa2d9f651241d1fa2badeae2a11950cf8685fc3efa1760b12c1bf0e34dae6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d828aedb214e174b1a51f2acb7840ace94a0a6f868f4ebd3c23c268450d836f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end