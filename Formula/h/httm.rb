class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.31.7.tar.gz"
  sha256 "593356f8e75f101406138c0220554f4653ea93504907745545ba6f1a1fd009a5"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e66fabf9f39f565271748e17783784afaa2667365b8c24cd626f08d072c6a0dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6e2754551b868542ede9aa693d06ce9225f8e74ab43bf977dcaa87cbba1c9cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdec281bd03f430df9eda26200b8768b1fe128aa405c1666972bb6857d928088"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc450ead5f0d18f75d020e24b59982ceaa821d48081d8bdece2e69da4afbb379"
    sha256 cellar: :any_skip_relocation, ventura:        "91a87e17390153ba3869e3b7708212c9e03791cdd7671c3184b92dbccb9b8045"
    sha256 cellar: :any_skip_relocation, monterey:       "b7ef60a875934505d6039a7d81b094190eb5f9967b25c5a93327883c77b7b532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b0a1f264732c24dd37910322c87aea9841c0544c45120583ab07f80e7c8459"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end