class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://ghfast.top/https://github.com/alecthomas/chroma/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "1945cbc31165917490ffb400a51aa90b9c726daf0b485369938c963ecbdc565b"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef51c9605d0a84090f70493b25514a7a5c841a5545cfbf0923463f72ff291561"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef51c9605d0a84090f70493b25514a7a5c841a5545cfbf0923463f72ff291561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef51c9605d0a84090f70493b25514a7a5c841a5545cfbf0923463f72ff291561"
    sha256 cellar: :any_skip_relocation, sonoma:        "4facdb26baa6209eafe170bc0b8d765d65064dc4586794c688a0837760233c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e462a90031503d4765b9e069d31f0f62518b6b0bd92dab82e152f7279d41a47e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7abea9deed72fdeffbbdddfcde438af1525cc6b4ca706a0c7cbf4ce361a31e6c"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end