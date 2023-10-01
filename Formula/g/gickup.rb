class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://ghproxy.com/https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.20.tar.gz"
  sha256 "4301301c3fc44d3dd9123e88415821a3f89d1d1e05aa9c7bd9a38f07e0ce0a0c"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efe89c187564e6c885f51a222ac18fef00372b290daa9b98f368394104776542"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f3556a161b447da2e28ff5652bd5fbd9ba6bde2466547f0f8e577b72fbd5c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc8641a961f92f0194b273d225f4fa09b44fbfc2805d92d091a4546e94c881be"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5533b3a013c98ac8fdbbd052cf513bc54e8d398f13364af76255c807b0139d6"
    sha256 cellar: :any_skip_relocation, ventura:        "4098a589ed4b02d0a21b247d2bb360d3d79810a02980b16266c25da639729550"
    sha256 cellar: :any_skip_relocation, monterey:       "f8cfb1365190e17662c3305e752eeb61c4e2f6f544cd21eb4fd1f876ab956b14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb1532e6b7696a67606a3c88b05e501727b148dcd162b20fe6bc83f027991aa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}/gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end