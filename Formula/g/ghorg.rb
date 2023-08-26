class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://ghproxy.com/https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "778d33fdad371733b63f019fc66ff1279fe8b9b2a7a1886ad8a0054c36847335"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bae49265692afdc0a81cf617ef631c67d38e295a4c2e7c7506aa8b07e0626681"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e3e295979f9cda37f5e437bb9b94b50af6f41d5ebd88569a7d976ba199ff5b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bea417cc7ea49ab59afb5f2c1f3053083b0dbf198b92a83e9be1a8d650982c6"
    sha256 cellar: :any_skip_relocation, ventura:        "a6f983321e5bebd7b7d95e928f27f20efbca973142d95ed5527acb481d539f93"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f6ea63e69433fcd5bf08f4e4279a472cbc964c4ffdfd9f9efd31883dd2fe87"
    sha256 cellar: :any_skip_relocation, big_sur:        "f582441d5ceb7962408d64f8c20459bd5f22983c5399bc67be5a29df204dd424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9a235c63a6040f71b4f36979c9b87a3105b6f40c31884dd370d77cb244eacc6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end