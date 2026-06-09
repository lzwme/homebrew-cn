class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.6.1.tar.gz"
  sha256 "55c30ce0a452cf531ffa3d7618d66fa8ccf7d26625b5d2f9cd142a38b659d5c5"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcf12286f42d3fb5706bf7ef54b5cd47f55433e78ddbf72a42c61d744cf412c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f9464294beecec85746bc457e035302fcfea6e65f12c257970c3e082fbaf506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7d98724669f22f438e6e23f9c9af2e5bc816e7043b6d196890bfe3c29b33d92"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4883ef8ab528c1b99e2ea2a8e61d39ecfcca3e2f487e789140a5b6ff6dd3352"
    sha256 cellar: :any,                 arm64_linux:   "04194aa1852c58e74c2b592d5a6b47a5dc2cab5fc284059621a44e372cc05705"
    sha256 cellar: :any,                 x86_64_linux:  "303e072e0165014b9deb9e0a8c37e1724ac74a13ebd909b5b5d1956940d3321e"
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