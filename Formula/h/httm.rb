class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.30.1.tar.gz"
  sha256 "3503cd94dc822437025173244655b02c357234097eb62b7e0136618cf51726dc"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee0f09e97f45f71b18cbd7d2ea03f4ba855313966c0d0fa9009ee6b711b7f3ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74f8efb1158f9d667f7bfbb7d6f09ee6d37ce80e9cf351d5498de30e575be9b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876655f345356b40ae047dda468d5cce4f344f49c949dc4711eaaa4011dc2c86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2bb323c36dbd79d9cac68bd39e1423a0d2f3f5f855fe0376524b7a4006960d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bf385e86aabc9788af8c8b230cca3f8572fd03aafc19afa84b5b06f445adff6"
    sha256 cellar: :any_skip_relocation, ventura:        "d04862340549eadb481f1c81427d016517f6cc65e2c8f71a391104a00a18d26f"
    sha256 cellar: :any_skip_relocation, monterey:       "64c42fdad088ab45669996ead89124882cd2d083d8c016cb88d13cbd64740c85"
    sha256 cellar: :any_skip_relocation, big_sur:        "f76fa504021fbc68dbe40132362c19c777d9fc758335df6230a651748a36fd0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dbf11e4c3e110d4e428b9ae668235664ca91bd8b6de184688aec8d7c0ff3fc6"
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