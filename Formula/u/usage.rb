class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.3.3.tar.gz"
  sha256 "5681ca5a6a398ed6673c2053b34c7088154d25b7aa7fb3363835b247d0fa4b45"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd088878db0106529872da09aee186f359f1c4c131ee68732c7671de50ca80ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b5dbb3d779b2bd3018b2d063b683e869fef69201f876fb1a78bfd47ea66355"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79c902848035dc39bb6c0e1dfcf98833065867cd942df2af3f1a60cc8c0fc071"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c9dca974c2afdd21915c1ae32a2e19129c6ac17fed2dce39e78cec522939d38"
    sha256 cellar: :any_skip_relocation, ventura:       "952be9ed82407f64b2ac2f4e869fab99fab47fe18b6107902a2f390f778946ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d197fbe9ef3d650d37bc57b6923010e0a9521c8b266fb0cae4d8886bbd328ff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end