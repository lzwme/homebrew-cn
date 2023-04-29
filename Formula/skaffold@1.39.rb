class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.9",
      revision: "7ef291c03ae67dca01305c3cfbf5ebe5520eec92"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9446fc7480a76a86a1dc9e0d27458a7d919bcbc4241566a3a37062659a856f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea918de52118df74adbede1466acc11809681070aee52546f3e2c313c67c41cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61ab0803a29ccb39ff5f2b2acffd09c6be9bbc66b654ff3bf9f9c57fb2d12e19"
    sha256 cellar: :any_skip_relocation, ventura:        "c148e1d9d74a2a0ef6486939ed62084c3a20ac7f6711a2cf2e4feb933b52f955"
    sha256 cellar: :any_skip_relocation, monterey:       "f7e2c08a2e4aa4d76a2ce73620a808179111e26cc7c6b71d73851beb40e1bfc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5e5fe12e9f834360582174c4dd8055b51ae07c424fc31e6068dc3320da8fcf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d009889d441716ecdbbd309222bd2c98de765cc482a08bfd19225ba02d209c0"
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