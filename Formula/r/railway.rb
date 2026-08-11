class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.35.1.tar.gz"
  sha256 "faecc8d2adede53bf59db5a8509860fb9e1dd8048a1195908edac97c072b7b4f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47d94166c27b10252f16ce9f3723b9740a534f387887043a31bfd12f5e0d1143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b23b954050e344975421859585f498055ae69734188c027decd221958e405ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f343f7bb34b215533f06ad51928eb4a062dba8cdf0c5ddd42387b99d2e5d048a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ea1b7247a42d6748c3190ee87394c18c49495fdd1795801a42de42e3b5c54d6"
    sha256 cellar: :any,                 arm64_linux:   "6360a766043155542ebce47c219908a0280a606c69c81e27caad9dec06054f7a"
    sha256 cellar: :any,                 x86_64_linux:  "91c362e15fe6a95eb3b95b4f13823004076ad12218836ff5324afb8cae94e6cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end