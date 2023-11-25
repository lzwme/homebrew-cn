class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://ghproxy.com/https://github.com/brocode/fblog/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "f54b0cbd99c55799338744e7e71024a014bfe216bc237fd6e0c887a462a9a8c9"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52ba4ac63ad177aeb3471c2cb8f30c492c4e158a705245b11b6f8fd4ed7fb0dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae4a4cf49e2e3311dec6d6f75a4a4e3eb206baaab5a7e3a2461de4a035a6b50c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e555573f995a687dc2ae6df8b5496516cd5151b261f4920eb148b5809d8e0c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "59f6d44e6138b5c5473f01a63099db0dffbf335093e846b55a674f9b503c2ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "9132f1c2b52c251067db48eb03867dfa978dff33d44ba518537296bae16a5ae6"
    sha256 cellar: :any_skip_relocation, monterey:       "b889c27d2af8ed6584b34279e78bd5532f13b5646a182fe56286e0f34b0a6f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee672eedd80637918d548c4f3f449a007e9bd4768dac05e9a42521e079780722"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end