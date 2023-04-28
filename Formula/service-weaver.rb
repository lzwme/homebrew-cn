class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "fd1472dd9059da73c6eff229c9359677ef270dbdbe2f63ce228687fb87a6338b"

    resource "weaver-gke" do
      url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.5.3.tar.gz"
      sha256 "497ead64073fdbffaab15a77e71d55942b5bbd3f221eb9bc7595da57060e1b65"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebfeecd8db384375242264971fad1b8537d5ba506a70f2e37e3d4c8eefe60c0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4980dfab823c47b81cc7cc042055613f2dafa33fb5238f7b833a6dd20c02b3cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea33476a68754f79b16997c32e7fa8bb244c9395283c2188ce0d4ccd1413870b"
    sha256 cellar: :any_skip_relocation, ventura:        "60b7f4afcdefc29598ac8023ea488add393c16986c2cdeb3cf4ec586165f7231"
    sha256 cellar: :any_skip_relocation, monterey:       "a610eb13be17a7a065f02cd79ac0e1adc5f407de30cea6000f190e44fb892ac8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ae953eb4f3eaaae78c8d978961963f3a4e39dbc71e8c1ed297d75b5e732e2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0c0d74d30eaf288ceea3648066211d72708316f25d5e5b33da9e5f8633b506"
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