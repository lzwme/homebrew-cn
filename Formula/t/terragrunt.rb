class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.63.0.tar.gz"
  sha256 "728e76268637098c53a1def2614f3de3f84e0717f33f131e1288b939ea94c81e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54c97c57f46c7505e882753a82e4e35c68556f8c01c34e7015089360ef54f80d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72d52f94dd4497ecc8075e3f85df896764350585efdbe873c49d114b88db3ca6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e725513b2edfd0feaa836c2f721c710e2836bff4750c226062704ea934423ff8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2095a40a4d00365baad265a836ee84263397394cb6cd35056a864d6275aae3a6"
    sha256 cellar: :any_skip_relocation, ventura:        "72a5ffa7c5814ac7ca780f196ddd62f209452a5843cf4230c07c46e077c05d32"
    sha256 cellar: :any_skip_relocation, monterey:       "99b881ff0d385ee1e5bd3201310c35a50e1f16831c7cade11d3dcef98f0bb3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f8a4f32fb3e5f09266fa7ce61af492296543b27bcb969ba26698a73649a96d6"
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