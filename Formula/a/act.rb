class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.60.tar.gz"
  sha256 "e0067a2fefe7dfb47295bad361074ae29b35b17d0bff9602b507b0b96584c621"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5533293b8efc5d003e2f607626ac2a487c7f92202775f9541a0dc3a9f17bb931"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a82970717d947ac9324d5e31d07c4e9be015a226d1791e33a4b4628a056d7c31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01a5f990c8d15cda0aa10d1243c9406d5d7887d3d8d56aaabff2c336fe4b6bbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "d004c58656e5847eac9f2342e04a44d2b1f7993271692778678ba1e06abd4206"
    sha256 cellar: :any_skip_relocation, ventura:        "7b54a691f6f6eb6c1b83e10a09650ec054eb8653584aac83206adc21fc1d69ff"
    sha256 cellar: :any_skip_relocation, monterey:       "622380502004c8c82a6a31d200c1a16daf88b693909599d5e2882c7fa8002366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b99bab0b80fddc261a16cadafbb09ba7714b4cf90802b6f1bdd127e8607cff76"
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