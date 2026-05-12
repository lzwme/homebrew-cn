class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.57.4.tar.gz"
  sha256 "30e3873c7643283e54d6f1e2803680af6f270d6e4a5d572a3bb11290fb1fe4d6"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0b35f70bd816b8f533f69657e492e7cbcb8680545071803a67f29d91ffdaaad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "384cd1d38befe7d3b9270e874d87b35c05b7daeea54aedb6bde2b3050ae47ce3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bb542bf684fa9dee40d60efa1f08a07ec0dfaaf53d5a6baa150e821aa7e9ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bee17b71acccb1f6bb6f76e38b315b7476153c78db81de8330e0c1bbea00f72d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac1f5142bc5c64011a36d24ceb91e91278fd06a99b9e2b522ab7007d7a58df93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26067760e41b21e47ceed825ee76bdd0bc7acea13eba922a6f5480f211faa352"
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