class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.70.tar.gz"
  sha256 "209fc35eea72b91141e9a7e0037f2582c7b57c2382cdf0db282aa208da5dc621"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6a23eb72dc1f6ed5829ea8a6a809ccbae28bfabffefa64ab6a1525d1306c3f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a409b529e34622c358762140d94709797ca8dff6b73f4105e5f8a29a4366a83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55c9e598a204c95b889a60225a7c93f072c57fe70e300171d1392d42e0eb3893"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f2caebca5d7e69bd74cf5263a4f0a830e77c255158a382e5122a6f500cc4254"
    sha256 cellar: :any_skip_relocation, ventura:       "8de07ee5cb8a71b3e81c73fc5feb99bca1a1dd6438ae54fc863881ffdc71be82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d12c64de2be5d2db971f9c2d17d8eb6033c58b85c0c6e440ac37dfbf3b5ba3e"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "distlocalact"
  end

  test do
    (testpath".actrc").write <<~EOS
      -P ubuntu-latest=node:12.6-buster-slim
      -P ubuntu-12.04=node:12.6-buster-slim
      -P ubuntu-18.04=node:12.6-buster-slim
      -P ubuntu-16.04=node:12.6-stretch-slim
    EOS

    system "git", "clone", "https:github.comstefanzweifellaravel-github-actions-demo.git"

    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    end
  end
end