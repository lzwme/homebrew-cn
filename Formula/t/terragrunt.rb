class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.64.2.tar.gz"
  sha256 "5f0b692c1638ebae790b6366eb3dfd2fe3cd76220a2631db27cdb0f7320691cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8f04d8f9058bcb9639610d82993290484bf0d85c027d1c7f906b0bed4915111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cb287b2ec5060660da6118a4a8104dd74abb3d20cae1a7dc55bb00115e7905b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "838c8f2ecd29a6391ba3b3ac2c580e36a1ed48a6a6c6ad23c1c2ea01eba27a42"
    sha256 cellar: :any_skip_relocation, sonoma:         "055749186e5d05239da555748119d10029db87c651812d190465310bf8af9683"
    sha256 cellar: :any_skip_relocation, ventura:        "5e5e58434c9453630c2bcc14a09f09e8609076f24386ea24ead799e2320cbed4"
    sha256 cellar: :any_skip_relocation, monterey:       "9a682ce69b600758601be24c0afa1cd7be94598642849919f53db3f36fe5bd04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ea76bbd42dd530f9b129e4590d80034124abfaaa0678e3cac38c3d95d188015"
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