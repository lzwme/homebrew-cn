class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.7.3.tar.gz"
  sha256 "1196491d16082b589be5640db1027e03888b86a0c9ab77f546e1285dba9b354a"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21bbd1fa525d7188896d2f9ffb64db2855a5bdf692942103cc5c08baeb4d1be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "079ece5c2aa285ac0a59f67c486ab93e1d9415964117ace1dd33231a3cb0399f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "917ac3a0efef794ff7c7bdb8fdc0112c7b6e4e83748fc53495f6e670803b0452"
    sha256 cellar: :any_skip_relocation, sonoma:        "a12f2ee2b0b49bd82fc471a5009502230f6fb98a50c926511a6813cf79dac7eb"
    sha256 cellar: :any_skip_relocation, ventura:       "59cc20c2fab683a6f422da6b75c4f97e8773b1dc40d7ea03323b53b406bd6e2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f4355c1937a6d67ff6ae6b696f6cf54e530c6e03c5451def7648e6bf30ecb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d383f1b99f0271eea7865021b992b854c1fbd68495f073fd377cd4117a11329f"
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