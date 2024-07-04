class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.99.0.tar.gz"
  sha256 "fb64325656602cf1c4d5fe59cf99c7b8016309068464eb865a330cf97fa3cc1f"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f60336950433fcc288ef9db6c2fc799dee4c909a8c85b49fb78df4fef56f20a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f16bd8db4305057d9d158ad16d850285b6c0fa56493f2ffa5856f0bc59fdf1f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88820a3f81b8c20b55c85c59da0bc95af9c8b8f7114fe639eca0ef12a707200e"
    sha256 cellar: :any_skip_relocation, sonoma:         "233a92b129a5995e6def47b81665b78876852c3612bdbbeb76321127430cd4d1"
    sha256 cellar: :any_skip_relocation, ventura:        "25c64093279dc215cf7c8b1bc2cb3b1d24741f8a8f7f5504c7b2082ada0550f1"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b03399e6ca47065795a42be4137163483c90fa527f7afa0fc36395d409e9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a3796eafe00962d1570a00160cfd9c49b97c63e56be95878edea009311bc681"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end