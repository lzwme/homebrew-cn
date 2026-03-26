class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://ghfast.top/https://github.com/nektos/act/archive/refs/tags/v0.2.86.tar.gz"
  sha256 "5717a45d967ddbb5e227b4029dfde4d7757477ec2d828486f714f75695f05c86"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04a4e5a427028927ca4f436be134cb1c24aca9225a92587726d5e01f88f7f38e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d5cb6a9862803c2ab0d6f66fc7ea1553b6e737f086d450597a527c2afe87c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "424ab2b730b52ba4ec68a3cc0f9423d1f89a4b2f44e72b8bf29a2fcf1f4d3b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "8842068f78ad3f18b16366968f56c06fca165f977d542427816746b870500710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01a0c0b8189449a12abf090b8b5220ca5f200b8e39ffcffb798e4f677a542a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6abfa0f746db53587ca40122da2f8d8b47d102a7cf5fefe6b779303aa389ae"
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