class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.57.tar.gz"
  sha256 "7c903d270c82efcf31da5a339950a87b597f3c82635952f7bfd4d127667fb924"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e169f4a740146c2a89b7388bc7f860f07c00d7f0748adf9d2465c449fe88fa20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1685229e750f1c8051fb74d49cbb8f478df2baf29334af2dd94e65c81315f7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5d5f3714044ceea0ea9dc7f1e77fb4934582e0cf82dca9f98e02253efe35805"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a5894c949091ba7cc81ab979d8b2efb0a56f5ca476aaa175c1d522424d104b8"
    sha256 cellar: :any_skip_relocation, ventura:        "ff0c78911a181f1452aae08fd95dc47f97339b6c567d2e98d871013cf0defa8f"
    sha256 cellar: :any_skip_relocation, monterey:       "f261e0f2d9814afc4487a215143103935b2a15485ddf18e07c7a1f90e2ca48ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae0604d5c85a1a374a12e96b1df0ba2436077836ac0c379de801b02d4ef7bd85"
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