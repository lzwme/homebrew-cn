class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://ghproxy.com/https://github.com/filiptibell/lune/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "f620892c368766afcc01ca0dd67ab0336c0fbc21622ea492ae4ab9898990b751"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac894c0b403ecf44cf5daacac3666e02f60dd54470d820997630854f591a9b9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4823cda94262989bd778e4c5ebb08f5b1e2cb713f4e553ba662d90ff5c3dd99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7addc79bdc8751d6b1d26735058309789f0646a43696c9c701dd9712add7be7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ebe9d6f69900f9b616789401aced123f47be40c027838714a4196f76a4b69e0"
    sha256 cellar: :any_skip_relocation, ventura:        "8661ee7a4f540a422b7f5b86903343c8e4d80a1e55cf75bbb8a9ea28ad978706"
    sha256 cellar: :any_skip_relocation, monterey:       "2e03682ab10826b5714d4b9719d470c0c9f72b21419fcba84d0729b1aab7708b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb18ec9e749146573234a38d875adad138d2c5e6763f86a80597f64e1fc5739"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune test.lua").chomp
  end
end