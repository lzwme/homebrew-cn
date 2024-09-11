class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https:github.comnektosact"
  url "https:github.comnektosactarchiverefstagsv0.2.67.tar.gz"
  sha256 "1a93acf48f1b8bd3689c8c6c906e42ef0bb695199abfab488f11051e9f855b57"
  license "MIT"
  head "https:github.comnektosact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f20c5e9dab3640a074ba33d82330d35eeec2d7be0175ecd16f7c08d1db9136d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "539c62d9ec18679794a97731998db6a889c41cca8337126b7ce28ba0879c22c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a67b834847f221787c7f681a66d0e4dc11213122127026927a72466cfa2fbea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bb879e806322e48b29f35c690e2e6bf011d650c3646e9f0e5332eafeb3ea245"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5354fe7d0a79c1d45afb9ccb80b8defa43ab5397a21202ee7033b40571fa791"
    sha256 cellar: :any_skip_relocation, ventura:        "7c6bf15ddab3fcfb50b28214dc9092dc02af902e016e14f91f32442f10c98f9c"
    sha256 cellar: :any_skip_relocation, monterey:       "450489ab881dd7416cdd2bcde5ef23488c451bd378deb44b76199da0da344de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6000e18bc683ac0cc1cb7680dcfdad12ee4f057ed71363f82c64364cd19af54"
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