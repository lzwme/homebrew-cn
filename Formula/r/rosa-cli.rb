class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https:www.openshift.comproductsamazon-openshift"
  url "https:github.comopenshiftrosaarchiverefstagsv1.2.39.tar.gz"
  sha256 "8cedbfd32992fd730bdd6f3a5bfa6fb6bdb0a2d79c610006dfe16db8e07ad261"
  license "Apache-2.0"
  head "https:github.comopenshiftrosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ccf1443af39505365bdb98f0fefc0f269d3dec795048491d6c2d97504d586c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0feee37f6734b0d518b33bf9e0a200420e30f2ca12b41dab11091a5dbac6127a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc1a4d89af583339798d913fbda965af20cecc8bb949ebffeeabcd7a9f236f8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "962ce445dcb190baa3090d7aeeb8202712faed321d2ba5a6db02f0d4257ea92a"
    sha256 cellar: :any_skip_relocation, ventura:        "50fc6e0af5ca9b734305d12cb4565091d1b89c721d630152db2cac6640f2a965"
    sha256 cellar: :any_skip_relocation, monterey:       "e26336cb4f62994e33f24105fadb68f88531a08e647de262d18b0e9c599462ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cc2c6290ca8b1547cb1764d2f5691ed0e09cfd1e9bda70267c52df9fe3f5085"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"rosa"), ".cmdrosa"

    generate_completions_from_executable(bin"rosa", "completion", base_name: "rosa")
  end

  test do
    output = shell_output("#{bin}rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}rosa version")
  end
end