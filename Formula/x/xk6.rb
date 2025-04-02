class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https:k6.io"
  url "https:github.comgrafanaxk6archiverefstagsv0.16.1.tar.gz"
  sha256 "fe777541a62eead0ca68f40a23340c60d5fb5e319835484a17b802dd86ac682d"
  license "Apache-2.0"
  head "https:github.comgrafanaxk6.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2110f5d338f5538007afa2b272e852fabd1190274fcc418524d532866303df74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2110f5d338f5538007afa2b272e852fabd1190274fcc418524d532866303df74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2110f5d338f5538007afa2b272e852fabd1190274fcc418524d532866303df74"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b304f3820dbeee87de804a8b4691b1a56dd96fe23507eae3069a34af4ecb780"
    sha256 cellar: :any_skip_relocation, ventura:       "6b304f3820dbeee87de804a8b4691b1a56dd96fe23507eae3069a34af4ecb780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a29f594799fae62f64beebe44908d90f5e4fab0955f6aba6ad12ea70403206"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdxk6"
  end

  test do
    str_build = shell_output("#{bin}xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end