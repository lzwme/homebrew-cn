class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://ghfast.top/https://github.com/nektos/act/archive/refs/tags/v0.2.83.tar.gz"
  sha256 "a3580ad7230b62f8cce189eb2b82956fd4447b546f41075b2f8070c963a56a1f"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fab9444143abf179ca512d117e9420a130f802d688a4dc0af086340a8749a9a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e669b9d0c10bbd71383c9d4f6dca0007b411f556075528de398276054e4f0fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a22440c51136c548d9fbeb3032ccab7cce5d704c796a4dd97a436c8153b26417"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f41b6ff5e0ecf434322f507f62394f0d973cb08ee4d7b19b2ab7a33f48ecdbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e40a17b9961c52956825c08fc709e2bdcdb1adea5755e1f166c784186f62f11c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37df0ff1a6ee48fe4a4dee04b1e9f67926e0bf690cbb27286bf2744859bdaf76"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"

    generate_completions_from_executable(bin/"act", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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