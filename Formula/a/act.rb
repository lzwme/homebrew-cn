class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.69.tar.gz"
  sha256 "aba388bff6661d85ddb55262cb76c266c878ffd8f5b374cf9b3485f4b8b71e51"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b506a62f7a79cb1274f1b4e2ac063e99e8b21c48303f037a8d072fa7e72d51f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7f50bc0659b145e63576379ec94f799d4a18b05442126828cb78a4579e44d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b55f6f6d877ca04e0e8416d0659655f4b5949d43f054799760d36c985331fc9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "04027bfea83f4a73d50c788cc5cdecf8a06866fc7e208a89d9c0b1271e6b0f58"
    sha256 cellar: :any_skip_relocation, ventura:       "ca92a0306d5f17988f137e0711b1fffc1a4aa7038f2bbe96b50ec52ed788f846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30819c65f4c708e7cf5443017a5c16e27ffdccef8f2e1177b01886cdde982a4c"
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