class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://ghproxy.com/https://github.com/brocode/fblog/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "3b3489216db6671b26bbf68237ae81d9d983cc3a8e9d8814644f197f65d57792"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54f0d3087746dcdf7a201f778b3410865dc70d68b3ddca45e9ae3ce1de413524"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "263fadbbf5186fa2c70cf549177e65014a2ead00f427baec84b0236b9523e36b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59690ed84a0cccfee2ec717398e7f4870f1e707fd837f932e49ba1eb3bddf3e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d0a712cc5a1b7ae1cf66ee12a83da00568cbb677583b4f95ea1ee9719aca1ed"
    sha256 cellar: :any_skip_relocation, ventura:        "d056c582bbf59634a34a2736116d94b62640096e9a6fe274ec89fcf1383ff86f"
    sha256 cellar: :any_skip_relocation, monterey:       "c2cc71da55cf405df54d889e42f04be2456d3937d3ef0419fc44f48957320a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0452be44e50ceac77260bcecec4de4f2f78547b2225b2e0cf03ca6f3bd83bc26"
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