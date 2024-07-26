class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.64.0.tar.gz"
  sha256 "a63995531c33fee81d9904e581d6a137831a044131eb0249942763d56ff4bcde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7140366079cafcffc757b5dc6abdb8ac66dd5af587548ac938a6b0160dc10ffa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f17317acf7837318b6028d74e4a6251a5d1f80ec9f798ef5f3de5b99db59d0d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e99be7fcfc3c9dfaac9f9ad0a8a578af6efd758b80ffd1a0463ca71f502b08cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b81ba92c1ebb5c3d51db38e9c7eb17e14eeca34cf183fec81b251ac76a088424"
    sha256 cellar: :any_skip_relocation, ventura:        "d293bebc32f2f53a9b1161e72569230229340ef9c81a6c5dd0a57c9c77d4542f"
    sha256 cellar: :any_skip_relocation, monterey:       "534e5123581cb1cc3b54ae1e9bfd4852d8656b3c9c28fa98e25ce20fba1336d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee1705f5b044cc18d2d7547574a89660924e54f237af5ffaab246a1eb08c57e2"
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