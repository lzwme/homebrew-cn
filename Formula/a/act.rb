class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.64.tar.gz"
  sha256 "3ccc37c07203e02bceea1fb5a9b41827192285e1155fcc168d5a0f63c7b7ddea"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d28bf9a8324be32131be57c4b9272275280b09866fcbb04357d2a24e52f600b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16e7eb0086d01ec0ec4d3790f6ca57b8181787af050ba4b265a48d8c4f895fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5758dc43361d4ad1dc214e6d96d68927cdc1129778cb950b135e0b01a645c8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "75c5c1304a0b35e9dd3c9bddae15d83e032736c9190fce8d39efe1f0992748a8"
    sha256 cellar: :any_skip_relocation, ventura:        "d70af17006e89732ad10fe2d3c6c5c6d6741f84a526bd94515d30ef206755531"
    sha256 cellar: :any_skip_relocation, monterey:       "269ff3f51652c1c1ec20a4a9b9df07f278e81f14b5c9e9b1ce64ad68b5da5066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0232814525c1623bc0327bb93a6a0598637b676ed090d518208da154a4c35157"
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