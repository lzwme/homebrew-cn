class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.15",
      revision: "75e4fc7b81d4f523154efab48f22ccb5fbf4b004"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a4c60ecff1df334faea0cfb23132741b78a848b2a15700bc1e7b85c7ce8949b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef70fd239cf4cff0abe34db3bf1039b798b0404a09e50acd5a71fac1091b8075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a133420c6d47ef54451cf2d15da1d9fce6880f9c309a004284f9a53ff67796c1"
    sha256 cellar: :any_skip_relocation, ventura:        "bfdd650ba18cf24c6d19605a2b49ae4cc6510df9eb77c5aad9b8d27335069506"
    sha256 cellar: :any_skip_relocation, monterey:       "3159629791571c58d9bcc9a123a75f34cd9993f6b9bd8b02d5c6f4e18a0ee64d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4651d78188d2acf14b1883bff40c9c15f7b7c02574c3c988f544f88a3c0030b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b0028f460262a53a71d23e1ac67500c013e16a9f70c6c1e2126c718a9514f6b"
  end

  keg_only :versioned_formula

  # https://cloud.google.com/deploy/docs/using-skaffold/select-skaffold#skaffold_version_deprecation_and_maintenance_policy
  disable! date: "2023-10-18", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end