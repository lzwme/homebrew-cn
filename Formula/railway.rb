class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "c6ce2cedef7ffc8826273a5a68002f240118c103cfe9bd15dd3a0ab5a2fdecd5"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd6519f4ab5911a9bccb46dbd74aa3084cfbce4fbbfb46427bfe15415b722e86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68c85135d3a96e65b0025de243a66a4b8b58dc484a156916d0d4aaeefcc31a9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d306b8d37750384b3036fd22cd23ac1c6a4b4f48bf7f8491ffe07eadad6c401"
    sha256 cellar: :any_skip_relocation, ventura:        "a898ea0b882684606d97d7fc6575db3de620c12e9e02aac7f77e1644c6afa519"
    sha256 cellar: :any_skip_relocation, monterey:       "e0f289bdc76d3b11b7b107d5e2bb170190f10351fe0f1c96afae46fd825ef64a"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaa1a86f1f8d4b007cfe7b60ee3455142c1d972a4db01e4bc8061889d3bcfdf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32e07d3bc3e8d55ca332fd48ce87cde66ecb1d38885b463be26c725e49ad17f9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Error: Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end