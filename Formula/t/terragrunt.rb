class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.18.tar.gz"
  sha256 "d7ecfc2dcbc0a80e69f86aa63226293ce1b9cfe240451b169586ef877206e7bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f5214ba08d8ca4813efbda1be04d8fdddb5233a1c3ba86bcba7f28e4499b0b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29eb6ac8daba803801254d287462a032b5c2c315dc77d19c73deca591f7175d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45689e0bf085821c372cfa4afe72c4f8fad3c6dfd0ea015db9f636bd3e7c4537"
    sha256 cellar: :any_skip_relocation, sonoma:         "f649789c32382692b08d88229bcded40479d4cbc084685d6c3f64b249c9fe107"
    sha256 cellar: :any_skip_relocation, ventura:        "da0b8d479e15c6b16400a11220b07a04881fb7d450f8e459fc7e81ab841f198d"
    sha256 cellar: :any_skip_relocation, monterey:       "606e43f652955368ec0bf5a1577dca3ffc199ba2c334b3d3e3a67eff5d4f094f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bb9d117bd3fed593df7541fcea629301487879986bb58ff344ac8c144b1e835"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end