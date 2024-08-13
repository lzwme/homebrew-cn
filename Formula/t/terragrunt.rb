class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.66.4.tar.gz"
  sha256 "2bb0c356fc01f70222064bbaa41637f8def9636a3a6f9b7a190ba5592e4b2398"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06dd6b1701a29c017f9f484ffae8b1801cabfd71283be997f3dd42f3be545aed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76c9ea6adf0dcbda86ad291956c66b0fb4cd9c570d51289db67c4ba077db4070"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f9176e2a7466964fd7da72268169111e7ccfc9c052bfbb69c2155384b08a090"
    sha256 cellar: :any_skip_relocation, sonoma:         "7518abf464531e0c48456a455268c32dec83bd6c4dd98a672f755edb4e0f22d1"
    sha256 cellar: :any_skip_relocation, ventura:        "78a852f50cb08656f99f91574f22703c54c1f3ca78587907b7c3422281622491"
    sha256 cellar: :any_skip_relocation, monterey:       "92a0f44d0f43c990ffde876c33fa63ad55f895c881cd661acc4310b0f64f4fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c09e96be497a39c2751a2add41283de7a986a51eaadf48f80e7801ed9ea96f8"
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