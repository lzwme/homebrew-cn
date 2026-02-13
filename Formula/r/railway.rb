class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.30.1.tar.gz"
  sha256 "12bd3fe1f2e4e778926afe84ee4d20ce3a5cacd48934fec98c27708cb775657f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cb8c6cdaebb2986dc08d0c2575b5d09ea176729956dc15bc24683ba192301c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41de384a434a0c4b237f88ed2a830da381dcb2176a8926774890e0203b7ef478"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa03077c6a66827976cee8e1d5c12b95ab12917f6ddac52f7643386d6da6412f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ec4faf4e9a6b2e81a6ae91c7a219abce23c6dc1e6ac5f3f6457c293125402ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c83287d968d704ed991f03d6a31953c77859cf38e165239a86361b9c363deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65ddbab4362a88dee51e799383028f5c10658af95d1725df352d6bad4e0e4555"
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