class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.12.tar.gz"
  sha256 "b871582881abfff0f06e906fb76836ca765ab273af8f3e431b6499efaaff7e72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c7c20d490b78a2d8e3348501c6d69ff02a24f055be6601261f5c339e65b5baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7c20d490b78a2d8e3348501c6d69ff02a24f055be6601261f5c339e65b5baa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c7c20d490b78a2d8e3348501c6d69ff02a24f055be6601261f5c339e65b5baa"
    sha256 cellar: :any_skip_relocation, sonoma:        "798c6788b42870627e5ed827f0aaccb8c988231651e9d513da808e230a4d806c"
    sha256 cellar: :any_skip_relocation, ventura:       "798c6788b42870627e5ed827f0aaccb8c988231651e9d513da808e230a4d806c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6120751fa8568523d32ece6581939659a28d1ae376462afce9ac701307889137"
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