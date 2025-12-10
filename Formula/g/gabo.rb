class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://ghfast.top/https://github.com/ashishb/gabo/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "fbba5bfddeda1c820a3ec8b178953c4fd89d7fc75690d325bd5c957298dff2e2"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb5fffd10e9eac37b6eca0f1667165ad02dc6d3f91655deadfd3235adcab2be1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb5fffd10e9eac37b6eca0f1667165ad02dc6d3f91655deadfd3235adcab2be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb5fffd10e9eac37b6eca0f1667165ad02dc6d3f91655deadfd3235adcab2be1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7334017af4b41ce46907fd489eb9d3aea3e895b5094faa7b7b8753f5f4cc7e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d8d3f94d6a4c05a95d92f613b3d8ece1382627aff4aec5dd3f91cc977f9c75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c21c7cf791a18fa4687a6d82cadd8e3d9b5c1257be4bc90ff3983106cd1309a0"
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