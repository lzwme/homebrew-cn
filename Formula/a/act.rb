class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://ghfast.top/https://github.com/nektos/act/archive/refs/tags/v0.2.80.tar.gz"
  sha256 "617a34c78f8202e56be83c3e2407cd8a07c1cdf1062f3b184de7f25af91ac7ef"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4baebb612422598492ab017254dee3fb0883ad1bf121ea44a762e49e19bae3d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "322a5e36c23f0f19f923ffe03f37b5db4dc1abcc376a691dfe5a1fb2548040e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "612c72b2ae06a4851aee33c6cd1f27f3aa4cad904fe048aaecaff48e30150714"
    sha256 cellar: :any_skip_relocation, sonoma:        "27ffe44e1a028425bbc0541ab87e9e7b693d8b8d3e6b7a6c06bf65c9bb690d5c"
    sha256 cellar: :any_skip_relocation, ventura:       "bc3ffcb2f75fb6d7ac8f9a4017bf477ba2320331eba2d6636b6fc81b8b7022a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10f32ffbb1309dbf3c1723edd291ab740d96b452cd3f8fe0acbad3c521844743"
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