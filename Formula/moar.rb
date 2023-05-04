class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "93287d8b7fc287b6cbc1c2e830a3df618ec31e17dc6eaf5ea5fb72d75e3bc7e8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9a5b0826f960cfa4232527502508b26d713b7eb2ab0d6936fd3c55c11fccd8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9a5b0826f960cfa4232527502508b26d713b7eb2ab0d6936fd3c55c11fccd8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9a5b0826f960cfa4232527502508b26d713b7eb2ab0d6936fd3c55c11fccd8d"
    sha256 cellar: :any_skip_relocation, ventura:        "1b3fbd086baf2e0f8b81b382e480bc94d93fb66a6377c30136b76472c3c5e85e"
    sha256 cellar: :any_skip_relocation, monterey:       "1b3fbd086baf2e0f8b81b382e480bc94d93fb66a6377c30136b76472c3c5e85e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b3fbd086baf2e0f8b81b382e480bc94d93fb66a6377c30136b76472c3c5e85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56f6ef73cb005c0cc14f7f41106787a87f3a5daa8f8b47a0ad3b11ef7a525c07"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end