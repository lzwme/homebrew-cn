class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.40.0.tar.gz"
  sha256 "bd45fbcf522cea65b970c65ec52aa9c2956cffda088da743c6933e13392c09bd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de2ad457f633209a0c71599a98a10806750c5e0b52171818fb9864d4fe99a37b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "869f112d324295b6c40c46d93e293f8912f65c80b6b245c69fd595bf58a2f97d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f48c7382fa52d23d7fc71ad52783bbad8269a24329c71befca92bd77a3c41dda"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0882eb38d883c4b06847212ede6a6fa14adecf82276abe696f1d31ea08f13ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d46a3ac47f2f8a77979a5be8f9bb5dda211f32f9df72ffbe1ca9bdc8cf437768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22be81f7376db1b0f2c6ba5ac92769fbbae01bec086f0fd4d369bebd63c836d2"
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