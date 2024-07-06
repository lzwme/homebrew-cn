class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.60.0.tar.gz"
  sha256 "4b9b653cf395bf087883013ddff7b2e54f1a62b9423024310a81a31b0a063d0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1e8fc27f73e0e39784e828c3a8bfa4c2dc4ed6f40fa17b9719952df22facd32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09599673f6e38c34f84a1e19f472bbd54c9d72eef327a10394db93d2b1aa312e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da9e33a729ac32e8272a9c28a72cbf142b47a323edba9908420fb32a9a412d76"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfd41bce771499380fff621f61d5cf99876597fd4b391d84236339c47b6777c3"
    sha256 cellar: :any_skip_relocation, ventura:        "34e520ac407ecf94faa00dd47e321e8aff878113fbbd8b58fb220d28668e3939"
    sha256 cellar: :any_skip_relocation, monterey:       "ee44e850b748186ae0a3cc5df1f5c79301e74ca6bc22c65f31dc824f00dc8a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3062c6e7850eb237ee4864071b2c049fe797def0b9916755b8a54ce2ccbcc1e"
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