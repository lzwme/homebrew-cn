class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.1.3.tar.gz"
    sha256 "66ff87ce28303f40ef2e8bc4a98e8eb93cd400340c49caac81d792d822936971"

    resource "weaver-gke" do
      url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "58bd18e21549647e39127346fdc291ebe14053241000f6761841d77465b20f0c"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "345b8db4081be6ac50334e7b3f876051517c39475c8596b0ed3e5bc9003db20d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7cb5a88ece36fcde802238ce8c5eca79af5b9bcb18b9d655691b0a60562d160"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59c87bb57098437f49421012f3475a78e70de9152193c2e8d0f2337b4c1ef212"
    sha256 cellar: :any_skip_relocation, ventura:        "1b3bd0aaf0003f7c7ae428855a472ba98b2e71f842d4abdcb3f707c88547eae1"
    sha256 cellar: :any_skip_relocation, monterey:       "6a380c916acb7f131324f5ed9c77434d4c961abd4a6767245a44437de1528117"
    sha256 cellar: :any_skip_relocation, big_sur:        "adc5b5896c00d67560a42828663a61bbb91d7c46e4d94a31a7a96a9fc09e4a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "026bc89897e3fbb55f7b48f38df15c5c020049fd420904ecc0c6663608edcfff"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"weaver"), "./cmd/weaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./cmd/#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}/weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}/weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}/weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end