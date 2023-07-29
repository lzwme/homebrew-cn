class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://ghproxy.com/https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.20.0.tar.gz"
  sha256 "2b67d8d8c39e5fe95ab4a8f77c45860cfafec241e0078a59c2b14a6c1a0984ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "956885bfb0d9a45422fb3d38081df3b2339e3da5d8694afe9d9073ea09abce3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93141b309dd606263e06ca4c427d23591fd10b9ec1bd93977b9a57392f9e6e4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "574a9e8a2b8ce5c9b79a674455fb22d1b82f55cda60df3e2657016d6c3b80728"
    sha256 cellar: :any_skip_relocation, ventura:        "cdcf0eecb34dde56cfec6dcb9caafeb70459eec98b49922b453440986e46713a"
    sha256 cellar: :any_skip_relocation, monterey:       "8a08ee3ce5460a14e5af983692c86e9aa9d5aff196aa3ca16cf32e5e473ed7ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "05ee7daddabfdd894750b57e6ac8c7dbd3c60ec984f762503f6f13658f23867f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0827723447a29a06ac65ea09b358ddc9c767674cd0b494d2e8930507b675e893"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end