class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://ghfast.top/https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "29d780c69ac67cc73914b45261d9a58d55ceafd4f666d6de3e503f5f98869421"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "900e61cacd81adc0f4a649bd9b4d875ca1038380f51792e684d49796c64e280d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d5b985dd4f340a8cd316bfdc54c3e492eb3e922bf8fef8d3cf1dc2dfc1d7b2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "661c5572d54e0ec6008ad4154933cac9ad733242a04cffddabf36e9e9994496c"
    sha256 cellar: :any_skip_relocation, sonoma:        "021463d378a991c150c2e22ed8b44bded81acb821ac11175ff80e7151e74e81a"
    sha256 cellar: :any_skip_relocation, ventura:       "243eee462b61d656de21d92ffad9e544380a538ef135ce4e28be5b9e20878a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "594fc39ca723033cad9ee233a806c194c3604baec82e8c43d734170b67eb1019"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "geesefs version #{version}", shell_output("#{bin}/geesefs --version 2>&1")
    output = shell_output("#{bin}/geesefs test test 2>&1", 1)
    assert_match "FATAL Mounting file system: Unable to access 'test'", output
  end
end