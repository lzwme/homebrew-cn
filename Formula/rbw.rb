class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://ghproxy.com/https://github.com/doy/rbw/archive/refs/tags/1.8.1.tar.gz"
  sha256 "d401d1d37c1ffc6579fba561d7b497acf89dbe0a6191ec4cea2f1dd05dcf9cbd"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47acebc96ac8f05fdf3368f4edb1fa514f2fd6a7690908f2940e8caa681b714f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37891ca06e6d0c5f1a022abcd60a6875d66cc0f506b3fc175c3a021779ac0ca0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03f541154900893a52e9d749ba73587f3c19562d640f026583432188775d3de3"
    sha256 cellar: :any_skip_relocation, ventura:        "2b47e6cbf35ba141e1fbb335eb0dfe0163bed4ca3ab0529b1b6421d099b9ba26"
    sha256 cellar: :any_skip_relocation, monterey:       "aa9dd0a015b3e008559b8b2df3110c3b05f9c24a705744feabe96028b6deed0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fe742a596104613134ada161236c2c5d33a0b9482d0886c21eba3fc93850c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63bec05530f51139eb08384e5787fe2fd5f818052e551a33e7c15bd5a3c28188"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end