class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.18.1.tar.gz"
    sha256 "dfff0750046220b1fc5450883e99ff9e43744ab154c865404dab434a02823be7"

    resource "weaver-gke" do
      url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.18.2.tar.gz"
      sha256 "ae548510102e94c55b19be01521f90f7059478ccdd17b540ccc13dc477dfc68d"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "319ae34b5cedbb7fc57b26d1f906ec438bb98f59ad6d9fe7ae666a8fdeb6963e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a47cf2abb0ccbc719ac0a6e223e9859496d92538210553f065e96b97246c9711"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9a1fdccf718475411c9c7427851797c0413c3156e0dc9e5067ff80ec4817904"
    sha256 cellar: :any_skip_relocation, ventura:        "a84e7c0fd656608df266e2d97787ce73558347d15e4bbd2bb03fd4ac142db98a"
    sha256 cellar: :any_skip_relocation, monterey:       "9312b132952e598082732577e03e2a4b980df86462760036adf1446241fb2dd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca2f2385aae21d881fdaade8406d68183c3cfde7272cf43c185076743eb1e11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74607e72e33e14b2da53eca8c980bd8b7319d15f73cfa0112efce481e6c5fa7c"
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