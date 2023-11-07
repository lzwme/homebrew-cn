class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://ghproxy.com/https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.21.2.tar.gz"
  sha256 "aeebb1182e2368a1069c0f0ca611255649f298302687b737229ceebf5be291b7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48e868cd7e1fab1a48d25a68f35fca7ec82ed41fdf3be4c5bc276a48e7fb89de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30ad4feb16c4f5a0473fb9b809d73400028a16fd9f1109abbcdbeffb9ca5c04d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d628989e18da32799266dd002d486890412addf1325dd6ef0bd7c65a2784a72"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bf794b929fbbb5502d0b2a1a31f3b90e730012f0eb6a66aa8ba9db333e30a77"
    sha256 cellar: :any_skip_relocation, ventura:        "c8a7755b14a3be2fa3acb16c230b206762f07d28d5e9f7258427d4a9631c9fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "c9625c3b1c67bcfc77bed533c30edc0c5708870055db6910b684cdf140e897da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3841ea9d4ec8305e5033f7ecb99c5309451fb0c0311820cd1f0c213bde02106"
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