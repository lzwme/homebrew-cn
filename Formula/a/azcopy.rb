class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://ghfast.top/https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.30.0.tar.gz"
  sha256 "f5969f760f6e1f9da52001af797dbfef533e73447db985b9c4a74a9eb65b8266"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4f71c15529baa197f268b2198aad4bd1e534e8a9c3fe25ad380bfbfbf626849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d184da0d9b5294b4db4c741cffb68cd22ab275e3f59c3492c8edb973f818586"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e4d34e3cf3993f719a163f62433f8f8eba4bdd3107b792b78f4241dc8e55152"
    sha256 cellar: :any_skip_relocation, sonoma:        "d338a8e9f21d1bd92d47bcc9208e8470693c25bca6ae6036d181853c0f34767a"
    sha256 cellar: :any_skip_relocation, ventura:       "1445688d3a90432997923f4a9071e1c5f4e4f61d55dcbb97ce97ee8f1e8b580f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3535481600fc7c0a602194a45d8adb09384414d809b58a89dd66814646254a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6211497ec1961105e4df5c38dc2342b34d2245d1d09bc9d52e8e0db4b678f51"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end