class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.75.tar.gz"
  sha256 "9fc070cebba1e670005500c3415cd5f1c75bf991e96074256b9cf957701aac61"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c057958a694e34fb08d62790321f35ef755c8cd6b3e219f896913f7a32975fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc96975ff0318e706acb71a2ee6e1462b1d6b75f8e085d6e7723de976da79cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f4f34bf083448cd70bf6f8019be00f882f678c2bd4f311cdcbe7f8b3a01ecca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6cbda94c048d284a954f02f92837a5eefeb0f6d95f45c09188fe6a150f05453"
    sha256 cellar: :any_skip_relocation, ventura:       "8245c0eebafe98d06e8567e7936e7e84b2add6bddbc7d5c7302484f42f25b2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d791570420c103b50c8967c5ddeab91bbdc1b4a50cae62153e6624a61176fc"
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