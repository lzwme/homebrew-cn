class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https:github.comAzureazure-storage-azcopy"
  url "https:github.comAzureazure-storage-azcopyarchiverefstagsv10.22.0.tar.gz"
  sha256 "664c8670cf9b46a58dc9a6aeaa500f6dfd5c743cdf24799149fac84bd925369b"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dace4add9d3d82d90938a4f2dac3f530ffb2889001e5162e8172eb8f29810cd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78c380ccafd46fca181a2a422cc3f293999293c05a543af492e3e5d2bd97c5c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a931363d65e5f14188b99eb1ba69f076d97272c1e82bd95cb1ba948464b0795b"
    sha256 cellar: :any_skip_relocation, sonoma:         "56725641ed429edb6af199b754dcbeb82c5bb891b0ffe2f24081de1fa10e4223"
    sha256 cellar: :any_skip_relocation, ventura:        "175129685ed9b10ded3daf32e6b41761125591f3f17bd2822bfdd3261c6d3958"
    sha256 cellar: :any_skip_relocation, monterey:       "a551edf88de10702ab298d8d540a9177c0f6d728e9694c10889dd6bc1962d9a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb278c94c2da37ac4b8e5b2dc6b3778601e32561639081bc09d5382012c64719"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"azcopy", "completion")
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}azcopy list https:storageaccountname.blob.core.windows.netcontainername", 1)
  end
end