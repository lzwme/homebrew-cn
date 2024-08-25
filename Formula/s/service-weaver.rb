class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https:serviceweaver.dev"
  license "Apache-2.0"

  stable do
    url "https:github.comServiceWeaverweaverarchiverefstagsv0.24.4.tar.gz"
    sha256 "00e1f434b0521a25fe205d2eb78490f6e8a13f15fdc989d4d8e26f2f50e21ff1"

    resource "weaver-gke" do
      url "https:github.comServiceWeaverweaver-gkearchiverefstagsv0.24.3.tar.gz"
      sha256 "ce009b862259fcf550c1a36faf3ae53f77289126bdd50b9d67cb880f216ed7e4"
    end
  end

  # Upstream only creates releases for x.x.0 but said that we should use the
  # latest tagged version, regardless of whether there is a GitHub release.
  # With that in mind, we check the Git tags and ignore whether the version is
  # the "latest" release on GitHub.
  # See: https:github.comServiceWeaverweaverissues603#issuecomment-1722048623
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60db371f4bac154898656b9820e443f08a5ba5e03f6acc4a97e45ef83b3acedc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da66eb356ec1c4c9035db4654c10a9b32b1b5ceee8fdd405ab8a23f9168bec7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba4965429a6c390867bbbf4dd92ff6ef4746a1f5ceabf6c4be48f2e3077bdb3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cfad3462c76b1283c3c773aec2ef58e3815fbba6df064bb9592857c56b2ddbe"
    sha256 cellar: :any_skip_relocation, ventura:        "86ea94f2ef99a815304dff4e76f46757a645354a7b681342223df643feb1734b"
    sha256 cellar: :any_skip_relocation, monterey:       "143ec06b963a89431bc1786f255a1a1f3215eedb3967217ecc9e644c4f29af3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656ebe886fad2773299045aacc2c3c7ef053473b4943b0f318bbdea262118680"
  end

  head do
    url "https:github.comServiceWeaverweaver.git", branch: "main"

    resource "weaver-gke" do
      url "https:github.comServiceWeaverweaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"weaver"), ".cmdweaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: binf), ".cmd#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end