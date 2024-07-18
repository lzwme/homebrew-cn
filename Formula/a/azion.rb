class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.32.0.tar.gz"
  sha256 "5433205e70c4baff10fbd634a9f20716e56a4bf35706e5a9b0dbdd24bfc9ec61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "198a57298a2afbba39bf2fcece61f56bdf74f3ed5834bc3f701556aad34d785b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a50f97e6503503627853fdc9c3986883124f53748b3ab268fb8f0e4cd5ce4bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5764197bbb71d02153ec9f147559e61bdb2700dc247eb1b6be1c643879cf77ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e8665534db0edd40c9f33ed730e9294980417d3014347931fc8aaf2dfcfb243"
    sha256 cellar: :any_skip_relocation, ventura:        "977fdc1ed5eadd07ced1ff2610b30febbc5f0906bb9a7e7fa18ac2d76c8225a6"
    sha256 cellar: :any_skip_relocation, monterey:       "cd36f8caec9f1cc8d4cd508c4f2e313fa41ba5e45302bb6a31850a6b47d32c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af411ff4be47d512acdce46bd88cb822f974fec468e2481a73ebcf6b3124c4b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaziontechazion-clipkgcmdversion.BinVersion=#{version}
      -X github.comaziontechazion-clipkgconstants.StorageApiURL=https:api.azion.com
      -X github.comaziontechazion-clipkgconstants.AuthURL=https:sso.azion.comapi
      -X github.comaziontechazion-clipkgconstants.ApiURL=https:api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdazion"

    generate_completions_from_executable(bin"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}azion build --yes 2>&1", 1)
  end
end