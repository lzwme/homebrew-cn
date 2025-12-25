class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://ghfast.top/https://github.com/nektos/act/archive/refs/tags/v0.2.83.tar.gz"
  sha256 "a3580ad7230b62f8cce189eb2b82956fd4447b546f41075b2f8070c963a56a1f"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "662b4f305718d312b68025d81c4b6464448c9618b908ab01d3551cd61ed22352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "083bcce421391b24f83662daea4afeba2079dede274d92fdc7639bd560475b11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e2b53dececdfbfa54ec5b91a8d2c839554e6a78a9998444ebf263dbacba42b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "288b4dcee1324691bd42563bc1728896b0c3f19f78f7406d2b0dd4882fb1d354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a6f56785cfb1106d0ded5b400a41ec551428eeeac96b02acd7fcd8b2b92fa7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1809f336174774435bf86bd02ea25e1777684f44f80f83fca0d4fdcff0558574"
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