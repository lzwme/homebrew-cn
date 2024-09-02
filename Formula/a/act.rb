class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.66.tar.gz"
  sha256 "128a88d966df451730448235ca0d5c804a642fc5f183fb613a5f4f92d9dc12e7"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a5e11a6b587bb00844a61dded9f352c68dc62fa3dedf0462d587688164b80a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ed87d2a0c2dc57a70ff1150e85a285e294c3acdd71ee43f5ed66f9230bd7152"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d449ff744d42287d200f4752cd648f7456d1fdd34f633db626bb7abfaea6ed5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ea0ca2d75716d6bf62f020990f908a16891597e59dd9affb4b5b4c991d7361f"
    sha256 cellar: :any_skip_relocation, ventura:        "f5477a357920803903073eb6ae5eb69cf147eb413db0c61cd7e94fa47db6dedd"
    sha256 cellar: :any_skip_relocation, monterey:       "9535b347dba1f79063f6bae41aea1c1f95f89c166b43aef6ae5a690a0204b7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef2e57163398737ba649891e35da81ac55856a3279e24ddf270cce121b3c3c99"
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