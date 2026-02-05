class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://ghfast.top/https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.32.0.tar.gz"
  sha256 "71295b2fc2ddd0698bfb6cb27f2cf87d917fd48b02d8e675ae98b30255f17d8a"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be1ea6c9f8b53efca7e00bead8b4b76ba9d54c544cdd0f3f05ff4aa3cb64ba11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "302d5e7418552e9d67079c58a686b549ab34e01bdbd1d62aec340eb7603eb02c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb38a7fe071e4fee3263e08a04d5f59dbecce750edd988a743ddf242874b7883"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff5260139a22ed8c88157933e4f96259a48400b3d6590795d4e68304c99cbd16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "849a2746b2126b2c0aaec1c730824f2305bf244297caaa476a691d830fdf53e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32ab5d1477b8bf64b8509dd48e73d75a7cc655f3062c50b864b78f37f6cc4737"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end