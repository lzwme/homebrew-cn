class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://ghfast.top/https://github.com/ipfs/ipget/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "4a5016260d5a2be0f0599534f6faaaa3026131c4c13ef0ca30644d39a8ab9103"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d163e6d5db5ff6882311ad197c5cd407b30233c40e421a7aefd072899ea7746"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2ebfd1c24295e616273a8bdade66e4d6fa0cd6e1ec0ef944f3dbd4c29624f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be6deb150fe8c9e59bb3a1eae1ba9d2e603842f25183f5f2d23b69f9db24c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5bac4d9522be84e422661680b6e32df0da1d7d71b2148bc79da6ecdb182b7ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a45a70d52fde5147524156ce8f357c8ce2c26faa6a5ef34dcb574cc718035d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b09debcc769e34d7248d13df7b391f84e11ee5d782cfda9ef8b46770fa4c56fc"
  end

  depends_on "go" => :build

  # bump cockroachdb/swiss for Go 1.26 support, upstream pr ref, https://github.com/ipfs/ipget/pull/189
  patch do
    url "https://github.com/ipfs/ipget/commit/8788a6e7c33a534a5822edcb973b5467274c9858.patch?full_index=1"
    sha256 "a9da66913347839ecfcfcd95ae833e59d11700a56b377fe7b8e4c21fb9211115"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Make sure correct version is reported
    assert_match version.to_s, shell_output("#{bin}/ipget --version")

    # An example content identifier (CID) used in IPFS docs:
    # https://docs.ipfs.tech/concepts/content-addressing/
    cid = "bafybeihkoviema7g3gxyt6la7vd5ho32ictqbilu3wnlo3rs7ewhnp7lly"
    system bin/"ipget", "ipfs://#{cid}/"
    assert_match "JPEG image data", shell_output("file #{cid}")
  end
end