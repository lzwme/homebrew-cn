class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://ghfast.top/https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.4.tar.gz"
  sha256 "83d7b865a8eacec1cbf9c66458beaf18e440968ca6f4ce45d325d8309268dd31"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "698a532243b7c8b566114b067a3abb4e89758f6d49258aec2543ef39bc0f424e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eba4d3a76a5a617aa068ff3f3a2da0a452a35be0c29991d2caf6b6bdbb8d1d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5109225bcfed5b961a63b115d78247aea0bad02facbd95cefa36971bdeecae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc9f5201631918dffe5e1bac1d411332a6136e04df9c9fdcfa7156f09bf2711c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73dab475819446ec1b23394b9a9b8e0c39bd9ce46bf93f8dc90ba610c498b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5246b23bacf294c6757af6429327f97025a6474f73f8182e29f3a930adae8953"
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