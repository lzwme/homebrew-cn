class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://ghproxy.com/https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.21.1.tar.gz"
  sha256 "6ddb6f6f291075aec5c9ab788ea5ab21dc957cadc8cfc4823851199755b77158"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53a4324834e8d7cfde541898bc4620c8f7b6f64382519a3dacd9591a85f61235"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67e873ed2205157e3f7db629ae389babd8cdc4fa7a2dd17344c71589ea2ef269"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63beac340c39e840e9cf789a3e9577faf2d188cc5c113f1574dd12a985e2de3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "140846f90c1fc89cd0b1a964d0a1d56fa9d1d1d6de8466c72ee79e96a7901f63"
    sha256 cellar: :any_skip_relocation, ventura:        "6926c5b49efa60aa5f14f8b359d699b1d8bb82dc3f991191ae2edc571526ba6b"
    sha256 cellar: :any_skip_relocation, monterey:       "8299d3265104072ead169646e4c03c9d8e46d7c5d6a1259b3b3610c555eb225c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a32548722dfd7062a377940b8f26ec9ec69e00607588017396e96d2bc8e62ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end