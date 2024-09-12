class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.7.0.tar.gz"
  sha256 "e58f46abc9704261c082dea705db0e91f4de829a8371eb68b734098741ff18e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "53d94c32d5fd4cc2634cb38e9f07aa37df2f78d96387b444aa67363d2f814dce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cfca12afdbca5fda7fa3fd60d7bce477e56cb2c945c22ea2242a66078eac122"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21a5eac20ba25656a04d2bd93bf79c1fe94ba3284f86d491f0f647ab92ea32c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bb95e179a62cb55ea04eb8277b2d6b1f682aa83941197a4efa3c3cf4cd547e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8dcc5a4584b77c45007550b1e8d44f89e598f0b2f6e38d706d24a32b86b60e8"
    sha256 cellar: :any_skip_relocation, ventura:        "bdb697abdef579a892d4d2b17bf33b16da92216df0d69e4bc17e6e5f768879f8"
    sha256 cellar: :any_skip_relocation, monterey:       "64d97f7694e01698aacc1f055248c1c631f9f3eb48e856a6744646192fd84b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb1ef0f620a4354f7f38814deb4a6a2dab6f60bc669262cb2140719859ed7a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end