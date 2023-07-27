class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.18.0.tar.gz"
    sha256 "086cbb0a88c9631ea1400db5f0ab86d1798b3e7fac394a86c21deaae8113dbb5"

    resource "weaver-gke" do
      url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.18.0.tar.gz"
      sha256 "d05e14ecf9324512627b68807d8503a46d6f4fb2ffdb18cfa664364f49b59d49"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7847252835067d10af2d0cac1d8b82826e3ed92c5e33e6cc3bf6a3900eee3e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6806372a84a975ffaf46c523d1d4f2327e86b70a831429ef0a56db35fb7c6e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf0e9f8f536045ceb2b587d02becf14a31bda0749138cdbed5ee18eb1d0e3a3f"
    sha256 cellar: :any_skip_relocation, ventura:        "c22a5f86557faac0e7cbc9f31f9d5a469b531d34cd9eff523cee45e4e75b4383"
    sha256 cellar: :any_skip_relocation, monterey:       "3272a4c789cb5d0f5e42f470f43bd2cb6e2f774ee1ec1e6b7a915e7cd556d05c"
    sha256 cellar: :any_skip_relocation, big_sur:        "480a560530c7955c4e492b15d2e200aee514d11a65628aec5bd59bfe2641bbfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083138779af3f923f3d9a6382ca5b6adf88999aa617e6b8a472fbfc1c7ce0862"
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