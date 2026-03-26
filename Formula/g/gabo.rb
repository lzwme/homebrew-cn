class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "38447db6c429b6a22888c499eb4c32ff27e19ccf174df9755d16edb74d641aa6"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b26c5ede8d36fcb0e607eb3f3ac93d01fba81a3fc0002db6c4a1eded865e66d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b26c5ede8d36fcb0e607eb3f3ac93d01fba81a3fc0002db6c4a1eded865e66d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b26c5ede8d36fcb0e607eb3f3ac93d01fba81a3fc0002db6c4a1eded865e66d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d669a76734ee2bbcd63d45f088da0994f8a618a38202b3f01542ae8d1210e33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea40800c24d04d43487ef710195a33e9193bf5c207ab5d90eaa1be3cf5b92a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b062028a7235e0797fb5626afb8d6252ef952c1a26650410582c3a81326e13c4"
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