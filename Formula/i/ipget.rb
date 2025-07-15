class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://ghfast.top/https://github.com/ipfs/ipget/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "4e075d966cb6078dfd32b9985288f481d240d956250da3b940124d11a0a3116a"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06fd82270dc64d06966fd3fcf3626936b3b262ae5cb6ce8a1d97e01f940e128e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30d87c10392f449ea84b0ec1468d4c87f08d52a3e371443b4d38e15da8c3e37b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6de12d03bb1e8eb412028b5321d0ce25c9724a02693ac77ff7b518cfc814476"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c8d09300d393ce89fbcadd6ca2a75c0d938eb561ece4a3014b55cd6f47bda31"
    sha256 cellar: :any_skip_relocation, ventura:       "5a7f79d04fcbac4bf6f2cb89201fb27389e0e5b068f7a88cd4af73ec74dfeb20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dd909d57ae12e0f7b2ddbd8228a895c1873dc017329a61f96e48ea64211854b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e4bd10ea1ee72102e23ceb3d974c8dc112deb55d6a4d9a24fb7e1d9365b417"
  end

  depends_on "go" => :build

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