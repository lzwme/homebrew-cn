class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https:github.comAzureazure-storage-azcopy"
  url "https:github.comAzureazure-storage-azcopyarchiverefstagsv10.25.0.tar.gz"
  sha256 "e9e041fc24ff0a8c84156ead3911f749469d0f362db67e1a354ebfa92b55c348"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a12992b82d8a818b4f0ae5e9703763772bd84e3ba092d0296882f9044d41a44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428702f02b9625c45cf83ad4324051d1d2272eea77cdfaba45e68d153fd235e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea6aa123fddd2ff944458c06d67cf368d822aaf1dfac0e1e46d25e5ef2d0d04f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e776d2774e8fae4aec4cb4b8a22a2dc6c002dc56742fa4cb63ee0327e4d62c70"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9dab1bb6b6ad24204ae5cf5d45c28fea650353996186034c2601d3336caaab"
    sha256 cellar: :any_skip_relocation, monterey:       "1ce56caf8dcaeeb4b410665a3f4ce8a086c83378a2bc5628d0a1cbec16626672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0db8bdc5e391efcacd45266714c87375aea317d271bdb693575bae3089269c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"azcopy", "completion")
  end

  test do
    assert_match "ERROR CODE: AuthorizationFailure",
                 shell_output("#{bin}azcopy list https:storageaccountname.blob.core.windows.netcontainername", 1)
  end
end