class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.58.tar.gz"
  sha256 "f3b3e62209075fd6f8717a13d58afb4245e7dd968afd7b32ed757ca85c799917"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4af89806ebb9bf28e85e54b6792b22af2c611c922db9570deec2ab645966d1dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3af7c37e0eb2579aeeefd07e4c201f842b1f4b4353073b5b64f865f7400aa468"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5115fbb2b336524c1a8383f05c42443e730935319cc1dd98b1fae6a2451c21b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d83d0bcc99ad153f102600f843f6bc0c8c60f3feb06854b4c3972f2dfed0bf3"
    sha256 cellar: :any_skip_relocation, ventura:        "9ee9283390c29c2810cfe0f0869e33f4365ce4c97264924fd11050422df50740"
    sha256 cellar: :any_skip_relocation, monterey:       "3cc7352f01aa49bcc11fdd51b53c7a4d57836403c2bdb2064d57a1dea1153560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10d18aab05ed916e710e82188ec0290527618605c865bff72c8241770a70138"
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