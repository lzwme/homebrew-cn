class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://ghproxy.com/https://github.com/nektos/act/archive/v0.2.45.tar.gz"
  sha256 "49f6afd10253b4c4dfe36f89f633dfea325d5133a6eee8842e320994b2a08f39"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "728a058a9ac8c6bad86c9d993fe82b9d5bfd0cbe75519955c5c1a958c8a918e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b821dd68785733f03ffaf188a80000adaed14fc780dbf219deb752164f20996a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "618a4eeeb9320f31d9ffda447f321fb25b36fc18605dc43b9e1f17a63a49551b"
    sha256 cellar: :any_skip_relocation, ventura:        "45e32f4bfd3eae67f1a6e0ce87c62414164ee1ab761d98b15c61074015667fff"
    sha256 cellar: :any_skip_relocation, monterey:       "931352fbb8f59b0c0c253d3c2040bc7de383440ff6df6840bb078164a8954a60"
    sha256 cellar: :any_skip_relocation, big_sur:        "380598d5c04f48c466822a8d6656d3d1ed439c586f8baf7573c26fc08aada0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "764b2eccdbb8f1cb1af8099e564f7d57403cb80d639ca14bc52e5c18701cfd86"
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