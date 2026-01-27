class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "e603fb7a5ef69b7f1123b116047e625742de69040eac7abc572b747117851c2a"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "293ffaf9895bb0066f340ed758be07110e13df1a775590c5306202a0a175209b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc946259aba86c2c26675cd77ada6e5e81824f2e9fce20214cc2390907c517c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d34476b0516a179fa5a98664dfc33a88d0bdbc56aec00ed0bdcef55a80bd3d1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "abc84ff26fe4c22d983d13317f812c256d89fd4032bdc8154f7d9646925db992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b09a0fc4acdc81cc906dd95f94ab1abbac0a6be68def99cfced5ddcce8440414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b6bbc99d90fec268beddfe809daf1481b584b711aac73311831db66a44719c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end