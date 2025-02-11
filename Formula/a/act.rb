class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.74.tar.gz"
  sha256 "589e4d5f58ee180963f16ecbc083b7c1af58642a6704c49c38ce5fda95800105"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fe7d65e8be66089b46325b43f3498d25cc1a5adf38a2509856c53a67f8b6ca6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f553ae2ed5c31a6fceccfbc15a54d28b3dfec41744f8c25d3488d49c5e3f209b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0246b4029afbaa1e2a50bb3c24db0f579fbc2ed8fc6705067a55a6453cb5355"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2aa20e9bc8c0dbdfe7267e447e59dca24ae456891a9fd8bdcdb80e0a7f941c"
    sha256 cellar: :any_skip_relocation, ventura:       "7e6e468e55f620124d1f7aa92614f7cef327612201aad2726702a34ebf253980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ec5d1f30c8e4e0840ec490a7945ed7dfafec3100dc3c289e08ace6485b7cf7"
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