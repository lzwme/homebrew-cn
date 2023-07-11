class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://ghproxy.com/https://github.com/nektos/act/archive/v0.2.48.tar.gz"
  sha256 "cedc0a8dfbbfda423ca7e647cc30eadaf92e40321624721bd29aae4c4f0cdac5"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f46c1311c37000a97c5ae6a0933b46e3d6814c541e3aaa2ead5e91eec818d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfdb440b0745c6da3c748bc86a86af401cdc6f4403848647eb3025368a0f4777"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efd7bd046c4a93e645d37183d73517eedf4c93c4e2b4939695cc57e484733f96"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c502adaa3d43e558dc9fb4265f358d76414a237cb09c578501ab7b810baa3c"
    sha256 cellar: :any_skip_relocation, monterey:       "5a287c6e69db3a734d15e2cf19abc6b6fa70eb158e9485e876a5cc0c3d3c59fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a8245d519a61c203fba40c890eac106b729159405764394f7e23373950debd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ba9200cd4894f0530a2d9c084da1a43f9fcd4ebab316cdcd86894ae5611b42"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
    (testpath/".actrc").write <<~EOS
      -P ubuntu-latest=node:12.6-buster-slim
      -P ubuntu-12.04=node:12.6-buster-slim
      -P ubuntu-18.04=node:12.6-buster-slim
      -P ubuntu-16.04=node:12.6-stretch-slim
    EOS

    system "git", "clone", "https://github.com/stefanzweifel/laravel-github-actions-demo.git"

    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}/act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}/act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    end
  end
end