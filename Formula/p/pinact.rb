class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv3.0.1.tar.gz"
  sha256 "0eb2b41c97c5b301d723d213598a6d74f443ed61541b15446909866dbac6f0fe"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1afa21eb8c649140bfbab5d978e6d260210f64a153edc7d9b3b8ac4956e245b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1afa21eb8c649140bfbab5d978e6d260210f64a153edc7d9b3b8ac4956e245b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1afa21eb8c649140bfbab5d978e6d260210f64a153edc7d9b3b8ac4956e245b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b8239e354ceaf731fee3b8dfa556980ddcaa890d5b01e9ec6a840303e491f85"
    sha256 cellar: :any_skip_relocation, ventura:       "1b8239e354ceaf731fee3b8dfa556980ddcaa890d5b01e9ec6a840303e491f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79833e097fbfd3317cabd634f7fd8bba4fba1a207979fa378ac3977b4696a69e"
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