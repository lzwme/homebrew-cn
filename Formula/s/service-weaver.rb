class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https:serviceweaver.dev"
  license "Apache-2.0"

  stable do
    url "https:github.comServiceWeaverweaverarchiverefstagsv0.23.2.tar.gz"
    sha256 "9ffc9fa3497d3453ff1c684e2c6f80f9b2874c11896ff6679b515a6cf7a2396d"

    resource "weaver-gke" do
      url "https:github.comServiceWeaverweaver-gkearchiverefstagsv0.23.6.tar.gz"
      sha256 "1f8c20bd5cdfd5e0931f6208a4a718a84ded0a1798f80e27cbb2c02155bd5a92"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "005f73c7552911a25532a33d18b14e1d786e2d04b2e4559acf27aebc506de23e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1fadbfc9181320e12747ebc27cd88cae98d7b0a92f1f6ec084a6c6bb8876906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9ae8c305a831304604ad3b7738e30a6f7b744f7136759bfb5ef3df4c3bda982"
    sha256 cellar: :any_skip_relocation, sonoma:         "53ee5d0654c60d17eaad4df8bb9fb0edb4b372f6cfee073946ba4c8ad529da94"
    sha256 cellar: :any_skip_relocation, ventura:        "ff43f255275d0b706cbcee189d2f8fd9a06a9fd58d93c7d80f43f6448f265eea"
    sha256 cellar: :any_skip_relocation, monterey:       "ba4506bc0241e867854e7b6a119dd6daea5f25ede22bdf38236c026ccd54321f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee184581995faad0249e7d8a3b71a23e074fc058d4154e4a858e456c33148393"
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