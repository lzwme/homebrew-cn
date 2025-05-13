class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv3.1.1.tar.gz"
  sha256 "9988045463cb1769253fe04ed40754c7cee9b267dfd7e381c6c887752d002d45"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e24e1f6607d0f1538bc582137a6fbb612979fcb85a25ae38d24196aa27f4a63d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e24e1f6607d0f1538bc582137a6fbb612979fcb85a25ae38d24196aa27f4a63d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e24e1f6607d0f1538bc582137a6fbb612979fcb85a25ae38d24196aa27f4a63d"
    sha256 cellar: :any_skip_relocation, sonoma:        "af684ef906aa6a734b4cff70db78d5a62f83b5ca3bb6886c8dc4e25f75749558"
    sha256 cellar: :any_skip_relocation, ventura:       "af684ef906aa6a734b4cff70db78d5a62f83b5ca3bb6886c8dc4e25f75749558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26163a3855ce551b0728ab4b5033e111264cee912dd0a16bc172084c5dedfb2"
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