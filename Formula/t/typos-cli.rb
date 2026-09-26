class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.50.3.tar.gz"
  sha256 "64cad1fb73601e06b701456cc17a5b9b65536508e8299a27218175cae494c0f7"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6285995299223f044478ca8dc9e6c313d857620ffeaefc438d35ebf50715596"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df76d7380e00bd83eec418f827f0af63a5a4e70e11b46f7ddcf12a799edc40a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9762fdb228b3b81e5d8389b298cb675629bb8acfc166e97197084e882e73f09"
    sha256 cellar: :any,                 arm64_linux:       "bff32073b7add41e4bd9261db633f9867e102db4e862553a7213464ec2437e53"
    sha256 cellar: :any,                 x86_64_linux:      "6b15c1f61bc6f34108b2a0a15b68ce112ea45892dd9d68e8412874b5a2872aeb"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end