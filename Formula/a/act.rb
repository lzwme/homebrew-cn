class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://ghproxy.com/https://github.com/nektos/act/archive/refs/tags/v0.2.55.tar.gz"
  sha256 "29cd5b46551d5db9d59a6eb5781deb444cf283db650b77b39b1914a0b5af8baa"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "983b1b4a020bf91f050304b5c0be81272f5f16849220d4d03c60eb2dd997611b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cb83ca86a52a2ff80f389cc78cab95d84d37893558ee9780f6deec84e472bee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d52e3888da4879cb81bb50256a710656706ee283af815231e86556f4575d2359"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c88855a61c97dbf58f8e0049ba8853ef2351d4823202a3c741c1f7bed2a74ca"
    sha256 cellar: :any_skip_relocation, ventura:        "20f7b3c358b5b636c8d11921cfaa321555eafd57bdccbaab33ec8d3ca42f499c"
    sha256 cellar: :any_skip_relocation, monterey:       "7be1bcdc4d44649fe1b8aa091713b982a547a8c0d23ca07f7e83c2ef76038b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21bb919651c1387497f3692bb2e198aa9085267b7890973e587e7b177b71428c"
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