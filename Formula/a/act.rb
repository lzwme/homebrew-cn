class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.61.tar.gz"
  sha256 "bd75ea2c0d3e0063ac7e30780ca0ca38c35ddfcc9f07da500540aa87e32bb564"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d3f6138268a428a00c08080f8ab5d85c88a6fee19ee788bb18b4aa787ba2ed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2fff22f5f9d39b5f8cf5a510918b7f75b022871ab0a294b5364333b1caa34c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b36372ccdb6d3469f5f50d890cb06ff39bca003d264796bd79d0a79881c0ea9"
    sha256 cellar: :any_skip_relocation, sonoma:         "76ec6aa0d1d6c36490104573798ffd43f10e2f16cd92b82b96a3d6af86bb9d84"
    sha256 cellar: :any_skip_relocation, ventura:        "1b15d638fef1da3f680eb9096f093b9bec65e8a13a7274973aee2bb254bf47da"
    sha256 cellar: :any_skip_relocation, monterey:       "ed9b8a80edbf9f51e987a025b64ddc34f452d71fdf3e216afaf8d560503ed8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "531e5681ef85ef31be2ca8d6b6ae8b06034ee10e7de9c23b96bc3aac2183fcb4"
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