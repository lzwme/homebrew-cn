class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.6.tar.gz"
  sha256 "2d2d1db06cd1b1e1ae9cd5f85e5865e668cf7057f99026cee5156d8566b94aee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b59f21b19ee62f8ed43fbf07ea06fc4a952595d9f16a5eb045526f954c70f6bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e53db24ede9b6083ef6fb89ac47cc6fdd97ba1105c8b88e8acf1d72f6520ee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5fca5915821915d0de047657e7152417970aec846fb6cadcba21a85f52e3ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d69b8e1edf9f01e6f11db74af13b38291333f13e8c411eb6b089f09bd7384d7"
    sha256 cellar: :any_skip_relocation, ventura:        "bc20bea75db3cf834a455f3380134a9bb8405a67f29d2910e44627ea331db131"
    sha256 cellar: :any_skip_relocation, monterey:       "73ad36310a27e1873d3bb651bcd52f79cecd3ddebd291df13a2ba21764c2086c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a34383bca90eb8f49ad0ee3286251d49d2b4f7dec3cba63a01adb28cf9d953d"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end