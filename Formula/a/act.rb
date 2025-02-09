class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.73.tar.gz"
  sha256 "277553ddf99d1abd15e9e0fc40301bd159bb946e2dcd9f8ca8cce69a757a839c"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdc28b09167a00384290b09170498706020a6444dd552c3df28a6ed1db5d9518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c86b93f1949e5923c08b720a45afff0395c3eab6ee66e35b98378373b95d89a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c99b02baf974026c16f31c4d68bb678329253cf06e2435fb3208ca89bb394d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "32fb7bc58ffc7e29124daec4c47387366673ae5726cfcdfa4568999f0eab2c43"
    sha256 cellar: :any_skip_relocation, ventura:       "a4879f5a54378665ee8d6d4820e3e26cc422552ae9f4d8dbbbc84904b6bb63f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c97a8c6c920913c86287a3b104721096b6a6f98a3b745d5a5d33135e788038"
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