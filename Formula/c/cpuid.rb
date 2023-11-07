class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://ghproxy.com/https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "7a32884f6adb94f870761bf3d174c6216d56d8ccd12ae1b00e220466cdfa290c"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d080e3e206d595fda2d83d9d2e3375d08e2c8c971fe7f7840fc54be255b139ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d080e3e206d595fda2d83d9d2e3375d08e2c8c971fe7f7840fc54be255b139ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d080e3e206d595fda2d83d9d2e3375d08e2c8c971fe7f7840fc54be255b139ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "88f312108e68b4e01833c65d2a3ce0181440386f7c8e6f5f30ca05f3f304b523"
    sha256 cellar: :any_skip_relocation, ventura:        "88f312108e68b4e01833c65d2a3ce0181440386f7c8e6f5f30ca05f3f304b523"
    sha256 cellar: :any_skip_relocation, monterey:       "88f312108e68b4e01833c65d2a3ce0181440386f7c8e6f5f30ca05f3f304b523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec31059044fa32595435d45dbe6deee876df929fa5e03000c31abf9572b466d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end