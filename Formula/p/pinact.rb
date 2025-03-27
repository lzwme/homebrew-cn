class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv2.2.0.tar.gz"
  sha256 "047745c193add771fb49f16dcfa49f7f186eb74b510296faf49b33a04a760090"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cb16ea61ad1fbf076a185e948b348814235e323a2dd87bc67ecb73cb04ca764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cb16ea61ad1fbf076a185e948b348814235e323a2dd87bc67ecb73cb04ca764"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cb16ea61ad1fbf076a185e948b348814235e323a2dd87bc67ecb73cb04ca764"
    sha256 cellar: :any_skip_relocation, sonoma:        "3077422e3d6c87cd4e132c3c3cea7833ae4d3c29baf83f41e246342fce7103e6"
    sha256 cellar: :any_skip_relocation, ventura:       "3077422e3d6c87cd4e132c3c3cea7833ae4d3c29baf83f41e246342fce7103e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2cb07ef1e4ce8d8c84e08fea993e075669e290eddd79e75ddfba7453cb2dbfb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdpinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pinact --version")

    (testpath"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actionscheckout@v3
            - run: npm install && npm test
    YAML

    system bin"pinact", "run", "action.yml"

    assert_match(%r{.*?actionscheckout@[a-f0-9]{40}}, (testpath"action.yml").read)
  end
end