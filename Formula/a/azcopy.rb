class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https:github.comAzureazure-storage-azcopy"
  url "https:github.comAzureazure-storage-azcopyarchiverefstagsv10.27.0.tar.gz"
  sha256 "ecbb297e7ce56eed10b4171d71c25aafae44f1fb5d64ba1bffebc87331bd5e20"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb4b715f5e99bcaf28f6cc513188dc7d254a170572e39ed5985bc802f32a6db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccee24d599e8ab9dad5c03a32e3088848d2111569339c182a5e231064eeb9eb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee44c8027ac4796ae0c578e2305f70584d4c068a04597800ab44517fa8c1a75c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f836e9b9ffc05f47357318a5639410836d3e0612668730697168d1d6caca3675"
    sha256 cellar: :any_skip_relocation, ventura:       "c60d164a7d7237a3dfa5572e1c55ba30cf0c66ae7159f8ef34ed254690488bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4db76a764f1c960723721b5f0e81429c676259631ba65a13ccc67dbce6104f5c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"azcopy", "completion")
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}azcopy --version")
  end
end