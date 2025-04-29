class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on MacOS"
  homepage "https:github.comphilocalystinfat"
  url "https:github.comphilocalystinfatarchiverefstagsv2.3.2.tar.gz"
  sha256 "569c87acea2ac377db0c2e95ee3743b7237e6a8f8bcc4724283c096eeab30a11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aba9c37e90515789e4ecc40f2149efd10aa97fa0a88f59c61218b9a5eaa42a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ad32e4f2910cf4f320eb9f0faa0fc1a5a5a8f4a3c21f174dc41c01ced4a30eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b171824de246eb166e0b38c27549f3c1572182c8a984165512c759d228b20c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "316ebcf36a3e11ffd1f51fd8ac03f648815e7aef040ad62025c7219d529d1c78"
    sha256 cellar: :any_skip_relocation, ventura:       "bcb84631c826273017f5209af75461d43382c567143334ccb3ac52166e83301b"
  end

  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".buildreleaseinfat"
  end

  test do
    output = shell_output("#{bin}infat set TextEdit --ext txt")
    assert_match "Successfully bound TextEdit to txt", output
  end
end