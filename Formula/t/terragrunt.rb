class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.64.1.tar.gz"
  sha256 "68f2cfa7f0660b0b7b2a251d00f8c1fff0b417d841882ada64dd94b90248a3bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63a892d4cb523288376118e138d32dc16e2f36b8f54d0a3900b6771564510ea2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8cd948c150f217a5fed721717d23d5e648c16145d43bc352dc18d6d6f4d53fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea27c810a952fd99629d5847c3043064eda30dc718f5783f8ba056efa86f39e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e5afe2861047cabc739ca292c9f16ea69f8dc46aa65d67bb246e935496a6563"
    sha256 cellar: :any_skip_relocation, ventura:        "51adc8db1e41692fe3f7316972a9c263388547efc3c7fbcd2820eeb26b16d139"
    sha256 cellar: :any_skip_relocation, monterey:       "50a2f18b6aed72c578707478dea9f5405562bf1733bf3e9688e0fbc5bdd831de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631de35b6fcc4788e223015214f0c976671ccbd047a691be228e5587bc6b29e0"
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