class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.23.1.tar.gz"
  sha256 "592a46201fa9675cbf218e7247b1220d89fad680177b3accacfd9e5fc0aff703"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a419b8703c0719664c271825ff9873bfce167ea3075c4bb621be4ecfde7a5c32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e012a0722d0c58081133dda399ce56fc6d3d96e925642e25d85b5a835f9aba2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b26f1dec23dd41934bf92340b2e8d5f02343acc622df45ae92e9c8653b26aa10"
    sha256 cellar: :any_skip_relocation, ventura:        "0a977eb3428e19266e2501b875a5a3c182c2bde922caa64ba7f19dd8dd7f7e68"
    sha256 cellar: :any_skip_relocation, monterey:       "6984d92586c886dae500d86b5ed59a743f993d4e9cec8c2a69ca3ef7ab76c1c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d20f49ff3c5897b006476e19a4444a9e8a29919696afb86921fbc2278bbc81fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "329aed20a81489d14ea16f8c34cad9dce0b422538afd47d8503a50f460e7266e"
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