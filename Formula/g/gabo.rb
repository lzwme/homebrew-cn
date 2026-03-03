class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "e17835e38a2cfca5da86bf074c0b3560e3eec3ba69d8fc19cbd1e40407a7adeb"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42453a67c26248d3b55a58152ff3381659f926dca19327b45107e2a8805a328a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42453a67c26248d3b55a58152ff3381659f926dca19327b45107e2a8805a328a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42453a67c26248d3b55a58152ff3381659f926dca19327b45107e2a8805a328a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a82ab26a00b1557723a04baee1fa95dc0acb9cade4519d33bdfd8bac879b711"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f43ca873e3e561865e6198280ddeda55d93855302c5dc6297c3e1db4383f852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a0ca45601beb77b6ef440cab41af9f8a4d6dec79b04ed2362bd68e528710bc2"
  end

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gabo --version")

    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_path_exists gabo_test/".github/workflows/lint-yaml.yaml"
  end
end