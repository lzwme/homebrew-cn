class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://ghfast.top/https://github.com/nektos/act/archive/refs/tags/v0.2.85.tar.gz"
  sha256 "bf4a7a71d98909c7d4ea604f16da5bb740559ba36955ea65ebe6b32951e7dce0"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f9d6d7b0c8a7c53d537e430f5bfc5d695336fd26e20f52d210c7f82c555175e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b3010f4edc561028b1efc3e920595617d39c92f49d78a0c4177567eaf102f17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a341c7e8a5bc8dca6626d40356cb2aec434a31d743d388790562fcd185fbfcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "597a630ed75c41779f74c630810adc4224c0fc2528b2e1eab0556224ce379881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f234503f5ec2161722b296755d57030c51d23f9df40b5f9b1769803451c1216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99a89516a0dd739f45bd74c3c92370e037c75adaa4b7e57be6002295f4790ac1"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"

    generate_completions_from_executable(bin/"act", shell_parameter_format: :cobra)
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