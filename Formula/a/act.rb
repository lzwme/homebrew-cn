class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://ghproxy.com/https://github.com/nektos/act/archive/refs/tags/v0.2.54.tar.gz"
  sha256 "3a85071cf9dcd5a6fe1ffc2ab36793cce87e1593182e8ba0b3c9e34b30309695"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc8eaeb55624f3da5355792c83d586b498c75a3080fb2b6666ae5dded76ad66e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "545c5b6c75682a389fd6abe8d2e77d2299991f3d31b817837ed1603ac20e2acc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f59bc7da67b9ca488b5c1260e2442396b90ce29ef91cbcb579f2ccb3edb7d3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "15e8f1244e153ce41979a9b23ac73f3bff1f3b49670fd1bb351ad769f3cb5d44"
    sha256 cellar: :any_skip_relocation, ventura:        "0bcb12d4d8bfd838c396a55bbfda9d61eb4e229b21028f364b15a3d23727bcdd"
    sha256 cellar: :any_skip_relocation, monterey:       "aae0b3ffc6e92fc123912bbe752439a49d6bd64f16ce02eb98f98fb3ffbf0f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7e69a8b9e81d967dfb48be46a2067ee9cc14efaf58050dcaa5fc3a870918e64"
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